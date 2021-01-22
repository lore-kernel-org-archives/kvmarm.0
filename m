Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF0DC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FDA823AC2
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FDA823AC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C25FB4B106;
	Fri, 22 Jan 2021 13:53:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2v1zGgUznipB; Fri, 22 Jan 2021 13:53:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B368F4B117;
	Fri, 22 Jan 2021 13:53:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98864B106
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:53:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TmjMBFPS6Zwi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 13:53:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0A984B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:53:51 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B8F623AC1;
 Fri, 22 Jan 2021 18:53:47 +0000 (UTC)
Date: Fri, 22 Jan 2021 18:53:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 10/21] arm64: cpufeature: Use IDreg override in
 __read_sysreg_by_encoding()
Message-ID: <20210122185344.GH8567@gaia>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-11-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-11-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jan 18, 2021 at 09:45:22AM +0000, Marc Zyngier wrote:
> __read_sysreg_by_encoding() is used by a bunch of cpufeature helpers,
> which should take the feature override into account. Let's do that.
> 
> For a good measure (and because we are likely to need to further
> down the line), make this helper available to the rest of the
> non-modular kernel.
> 
> Code that needs to know the *real* features of a CPU can still
> use read_sysreg_s(), and find the bare, ugly truth.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 465d2cb63bfc..fe0130d6c0ff 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -602,6 +602,7 @@ void __init setup_cpu_features(void);
>  void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
> +u64 __read_sysreg_by_encoding(u32 sys_id);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index aaa075c6f029..48a011935d8c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1149,14 +1149,17 @@ u64 read_sanitised_ftr_reg(u32 id)
>  EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
>  
>  #define read_sysreg_case(r)	\
> -	case r:		return read_sysreg_s(r)
> +	case r:		val = read_sysreg_s(r); break;
>  
>  /*
>   * __read_sysreg_by_encoding() - Used by a STARTING cpu before cpuinfo is populated.
>   * Read the system register on the current CPU
>   */
> -static u64 __read_sysreg_by_encoding(u32 sys_id)
> +u64 __read_sysreg_by_encoding(u32 sys_id)
>  {
> +	struct arm64_ftr_reg *regp;
> +	u64 val;
> +
>  	switch (sys_id) {
>  	read_sysreg_case(SYS_ID_PFR0_EL1);
>  	read_sysreg_case(SYS_ID_PFR1_EL1);
> @@ -1199,6 +1202,14 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
>  		BUG();
>  		return 0;
>  	}
> +
> +	regp  = get_arm64_ftr_reg(sys_id);
> +	if (regp && regp->override_mask && regp->override_val) {
> +		val &= ~*regp->override_mask;
> +		val |= (*regp->override_val & *regp->override_mask);
> +	}
> +
> +	return val;

Ah, now the previous patch makes more sense. I don't particularly like
this but I can't tell how to work around it. I was hoping that the
overriding feature behaves more like a secondary CPU that limits all the
overridden features. However, this approach would fail for FTR_EXACT
cases (like PAC, though I wonder whether it fails already with your
previous patch since the boot CPU value won't match the override, hence
dropping to the safe one).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
