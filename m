Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1ADCC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 12:32:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 158B449EC1;
	Tue, 15 Mar 2022 08:32:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iMYSv1-G58jP; Tue, 15 Mar 2022 08:32:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A188A49EFD;
	Tue, 15 Mar 2022 08:32:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 637F749E49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 08:32:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N0Z7lIrhc4VN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 08:32:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F006411D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 08:32:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F3791474;
 Tue, 15 Mar 2022 05:32:49 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 751383F66F;
 Tue, 15 Mar 2022 05:32:48 -0700 (PDT)
Date: Tue, 15 Mar 2022 12:33:17 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <YjCHcV3iyTtSrw3k@monolith.localdoman>
References: <20220315080152.224606-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220315080152.224606-1-drjones@redhat.com>
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Tue, Mar 15, 2022 at 09:01:52AM +0100, Andrew Jones wrote:
> Add QEMU_ARCH, which allows run scripts to specify which architecture
> of QEMU should be used. This is useful on AArch64 when running with
> KVM and running AArch32 tests. For those tests, we *don't* want to
> select the 'arm' QEMU, as would have been selected, but rather the
> $HOST ('aarch64') QEMU.
> 
> To use this new variable, simply ensure it's set prior to calling
> search_qemu_binary().

Looks good, tested on an arm64 machine, with ACCEL set to tcg -
run_tests.sh selects qemu-system-arm; ACCEL unset - run_tests.sh selects
ACCEL=kvm and qemu-system-aarch64; also tested on an x86 machine -
run_tests.sh selects ACCEL=tcg and qemu-system-arm:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

One thing I noticed is that if the user sets QEMU=qemu-system-arm on an arm64
machine, run_tests.sh still selects ACCEL=kvm which leads to the following
failure:

SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)

I'm not sure if this deserves a fix, if the user set the QEMU variable I
believe it is probable that the user is also aware of the ACCEL variable
and the error message does a good job explaining what is wrong. Just in
case, this is what I did to make kvm-unit-tests pick the right accelerator
(copied-and-pasted the find_word function from scripts/runtime.bash):

diff --git a/arm/run b/arm/run
index 94adcddb7399..b0c9613b8d28 100755
--- a/arm/run
+++ b/arm/run
@@ -10,6 +15,10 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"

+if [ -z $ACCEL ] && [ "$HOST" = "aarch64" ] && ! find_word "qemu-system-arm" "$QEMU"; then
+       ACCEL=tcg
+fi
+

Thanks,
Alex

> 
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/run               | 4 ++++
>  scripts/arch-run.bash | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 0629b69a117c..28a0b4ad2729 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -13,6 +13,10 @@ processor="$PROCESSOR"
>  ACCEL=$(get_qemu_accelerator) ||
>  	exit $?
>  
> +if [ "$ACCEL" = "kvm" ]; then
> +	QEMU_ARCH=$HOST
> +fi
> +
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index aae552321f9b..0dfaf017db0a 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -176,8 +176,10 @@ search_qemu_binary ()
>  	local save_path=$PATH
>  	local qemucmd qemu
>  
> +	: "${QEMU_ARCH:=$ARCH_NAME}"
> +
>  	export PATH=$PATH:/usr/libexec
> -	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
> +	for qemucmd in ${QEMU:-qemu-system-$QEMU_ARCH qemu-kvm}; do
>  		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
>  			qemu="$qemucmd"
>  			break
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
