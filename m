Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A8FC0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 12:05:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 866242189E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 12:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 866242189E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1A44A4FA;
	Wed,  3 Jul 2019 08:05:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C4O2qG-e+UBA; Wed,  3 Jul 2019 08:05:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF4D4A4D5;
	Wed,  3 Jul 2019 08:05:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 534BA4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 08:05:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bd9Dk9zligo5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 08:05:08 -0400 (EDT)
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7FF34A479
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 08:05:07 -0400 (EDT)
Received: from yt-mxoi2.gw.nic.fujitsu.com (unknown [192.168.229.69]) by
 mgwym01.jp.fujitsu.com with smtp
 id 3cff_0380_4a41787f_eb5d_4da7_9bf3_218c10e50d76;
 Wed, 03 Jul 2019 21:05:01 +0900
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local
 (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C5216AC0179
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 21:05:00 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local
 (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
 by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 6AB37BD67CF;
 Wed,  3 Jul 2019 21:04:12 +0900 (JST)
Received: from G01JPEXMBKW03.g01.fujitsu.local ([10.0.194.67]) by
 g01jpexchkw16 ([10.0.194.55]) with mapi id 14.03.0439.000; Wed, 3 Jul 2019
 21:04:12 +0900
From: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
To: 'Viresh Kumar' <viresh.kumar@linaro.org>, Marc Zyngier
 <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry
 <julien.thierry@arm.com>, Suzuki K Pouloze <suzuki.poulose@arm.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, Will Deacon
 <will.deacon@arm.com>
Subject: RE: [PATCH V3] KVM: arm64: Implement vq_present() as a macro
Thread-Topic: [PATCH V3] KVM: arm64: Implement vq_present() as a macro
Thread-Index: AQHVH3NpPwUf8hPIpUWmAfH1HAJm36a47W0A
Date: Wed, 3 Jul 2019 12:04:11 +0000
Message-ID: <8898674D84E3B24BA3A2D289B872026A78BA95D6@G01JPEXMBKW03>
References: <be823e68faffc82a6f621c16ce1bd45990d92791.1560160681.git.viresh.kumar@linaro.org>
In-Reply-To: <be823e68faffc82a6f621c16ce1bd45990d92791.1560160681.git.viresh.kumar@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.18.70.226]
MIME-Version: 1.0
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-GCONF: 00
Cc: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "Mizuma,
 Masayoshi" <masayoshi.mizuma@fujitsu.com>, "Zhang,
 Lei" <zhang.lei@jp.fujitsu.com>, Dave Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Indoh, Takao" <indou.takao@fujitsu.com>
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
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi guys,

I can't start up KVM guest os with SVE feature with your patch.
The error message is 
qemu-system-aarch64: kvm_init_vcpu failed: Invalid argument.

My test enviroment.
kernel  linux-5.2-rc6
qemu  [Qemu-devel] [PATCH v2 00/14] target/arm/kvm: enable SVE in guests https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
KVM start up option
-machine virt,gic-version=host,accel=kvm \
-cpu host \
-machine type=virt \
-nographic \
-smp 16 \ -m 4096 \
-drive if=none,file=/root/image.qcow2,id=hd0,format=qcow2 \
-device virtio-blk-device,drive=hd0 \
-netdev user,id=mynet0,restrict=off,hostfwd=tcp::38001-:22 \
-device virtio-net-device,netdev=mynet0 \
-bios /root/QEMU_EFI.fd

sve_vq_available function's return value' type is bool.
But vq_present is macro, so the value is not only TRUE, FALSE but also some numbers.
So It failed at 
if (vq_present(vqs, vq) != sve_vq_available(vq)).
I think it is nessary to make vq_present macro's value only TRUE and FALSE.

arch/arm64/kvm/guest.c
static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
		if (vq_present(vqs, vq) != sve_vq_available(vq))　// It failed at here.
			return -EINVAL;

My patch as follows.
I have started up KVM guest os successfully with SVE feature with this patch.

Could you review and merge my patch?



Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index c2afa79..dfd6264 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)

 #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64) -#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
+#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))

 static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)  {
--
1.8.3.1

> -----Original Message-----
> From: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org> On
> Behalf Of Viresh Kumar
> Sent: Monday, June 10, 2019 7:00 PM
> To: Marc Zyngier <marc.zyngier@arm.com>; James Morse
> <james.morse@arm.com>; Julien Thierry <julien.thierry@arm.com>; Suzuki K
> Pouloze <suzuki.poulose@arm.com>; Catalin Marinas
> <catalin.marinas@arm.com>; Will Deacon <will.deacon@arm.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>; linux-kernel@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; Dave Martin <Dave.Martin@arm.com>;
> linux-arm-kernel@lists.infradead.org
> Subject: [PATCH V3] KVM: arm64: Implement vq_present() as a macro
> 
> This routine is a one-liner and doesn't really need to be function and can be
> implemented as a macro.
> 
> Suggested-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V2->V3:
> - Pass "vqs" instead of "&vqs" to vq_present().
> - Added Reviewed-by from Dave.
> 
> V1->V2:
> - The previous implementation was fixing a compilation error that
>   occurred only with old compilers (from 2015) due to a bug in the
>   compiler itself.
> 
> - Dave suggested to rather implement this as a macro which made more
>   sense.
> 
>  arch/arm64/kvm/guest.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index
> 3ae2f82fca46..ae734fcfd4ea 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -207,13 +207,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const
> struct kvm_one_reg *reg)
> 
>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)  #define vq_mask(vq)
> ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> -
> -static bool vq_present(
> -	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> -	unsigned int vq)
> -{
> -	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> -}
> +#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
> 
>  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> { @@ -258,7 +252,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const
> struct kvm_one_reg *reg)
> 
>  	max_vq = 0;
>  	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
> -		if (vq_present(&vqs, vq))
> +		if (vq_present(vqs, vq))
>  			max_vq = vq;
> 
>  	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl)) @@ -272,7 +266,7
> @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg
> *reg)
>  	 * maximum:
>  	 */
>  	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> -		if (vq_present(&vqs, vq) != sve_vq_available(vq))
> +		if (vq_present(vqs, vq) != sve_vq_available(vq))
>  			return -EINVAL;
> 
>  	/* Can't run with no vector lengths at all: */
> --
> 2.21.0.rc0.269.g1a574e7a288b
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
