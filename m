Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B44ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 21:01:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F604C218;
	Fri,  9 Sep 2022 17:01:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FoNIgr82UxZT; Fri,  9 Sep 2022 17:01:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF64E4C3DC;
	Fri,  9 Sep 2022 17:01:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 467A44C3D2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 17:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yujva2UZAlaK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 17:01:20 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF4E74C23F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 17:01:19 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 s14-20020a17090a6e4e00b0020057c70943so6496883pjm.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 14:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=FkpmzbsfY+8dxCCfG0r9Ww9nyX3eXTahuSH1WMin7Dc=;
 b=d5SnEJ8gC7pL2uOB5VnHcz1gzpA9mqyytaDJg38QpmLUFP3SqeBZ4G6gv4Ekl5zreb
 dqQRaA17IzX5Hulxm1H5ysIn1+ihGbZuKRUQGWGAqiaYKD9OHLWwf/JpOrNQJzCNsAJt
 9Ywo5rmZV/pG3JUCueBORLmxIs6GKPkanIAXowk9UFKuDgK3LnYbs1TDLQ1sKWm0AabR
 o377kXjrykojNVyDvy826fNQw9ljZTnC/JbaIeBqJi+u3gwFiNzkzr6TycoY/Fz+Agwl
 iQnZnxBLLZn936IoxoZq5ZTYCaSWPA7pliJJDReLgJ0KEoiqpzuLQ1Y7GVuq7ANVhJDH
 C9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=FkpmzbsfY+8dxCCfG0r9Ww9nyX3eXTahuSH1WMin7Dc=;
 b=j+4sTWamoSloW2NOujXexJ4uY3RINZU1yHE77Sg1OYaUFNlcoAAoGgkzUJM5LpIZmM
 Bn8CMUML3KaDybfeMYNor9ralAm8iniE+tK63Ty95hEqcLRAOHLsPspIx77lkP17mT1e
 9DfZntqE1V8BYndhE7qG/cwzvRLlrVFVuCsLvFARr+Fe6fx5jf0DITd9aLO6nmPaQXsN
 kZfMINgfL8MPzUTrAfCSxq9EnwyZiAkHx5cgfAgUSt1E7iYWkBTjBbCYWzp+oI5xIlbC
 HeBJECWD+EjeqwqbqG10Db/cVsFJvDkfXrVvM7Lc3edrcs2XjZPuYmrYE66DwGpjSBS/
 7GHw==
X-Gm-Message-State: ACgBeo1MKE8KDgHxf7xobqca2Oui0BE/doFxYLWNhDyIPBgKomkVfMMq
 torfaLaO9g4a4h8M1+1machmTQ==
X-Google-Smtp-Source: AA6agR4GfLI2cDpWfESCM+hb1zOWhkcucKf0rKEpCNGuY+dxhJLCIqR+2m5zVrHL5Rai3U4Hr1+Fzg==
X-Received: by 2002:a17:903:291:b0:172:f018:cdce with SMTP id
 j17-20020a170903029100b00172f018cdcemr15341834plr.91.1662757278540; 
 Fri, 09 Sep 2022 14:01:18 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 r71-20020a632b4a000000b0042254fce5e7sm957692pgr.50.2022.09.09.14.01.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 14:01:17 -0700 (PDT)
Date: Fri, 9 Sep 2022 14:01:14 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
Message-ID: <YxupmpFFPOVx95w+@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-8-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-8-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Aug 24, 2022 at 10:08:44PM -0700, Reiji Watanabe wrote:
> Currently, the debug-exceptions test doesn't have a test case for
> a linked breakpoint. Add a test case for the linked breakpoint to
> the test.

I would add some more detail, like the fact that this is a pair of
breakpoints: one is a context-aware breakpoint, and the other one
is an address breakpoint linked to the first one.

> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> 
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
>  1 file changed, 55 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index ab8860e3a9fa..9fccfeebccd3 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -11,6 +11,10 @@
>  #define DBGBCR_EXEC	(0x0 << 3)
>  #define DBGBCR_EL1	(0x1 << 1)
>  #define DBGBCR_E	(0x1 << 0)
> +#define DBGBCR_LBN_SHIFT	16
> +#define DBGBCR_BT_SHIFT		20
> +#define DBGBCR_BT_ADDR_LINK_CTX	(0x1 << DBGBCR_BT_SHIFT)
> +#define DBGBCR_BT_CTX_LINK	(0x3 << DBGBCR_BT_SHIFT)
>  
>  #define DBGWCR_LEN8	(0xff << 5)
>  #define DBGWCR_RD	(0x1 << 3)
> @@ -21,7 +25,7 @@
>  #define SPSR_D		(1 << 9)
>  #define SPSR_SS		(1 << 21)
>  
> -extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> +extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
>  static volatile uint64_t sw_bp_addr, hw_bp_addr;
>  static volatile uint64_t wp_addr, wp_data_addr;
>  static volatile uint64_t svc_addr;
> @@ -103,6 +107,7 @@ static void reset_debug_state(void)
>  	isb();
>  
>  	write_sysreg(0, mdscr_el1);
> +	write_sysreg(0, contextidr_el1);
>  
>  	/* Reset all bcr/bvr/wcr/wvr registers */
>  	dfr0 = read_sysreg(id_aa64dfr0_el1);
> @@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
>  	enable_debug_bwp_exception();
>  }
>  
> +void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
> +		       uint64_t ctx)
> +{
> +	uint32_t addr_bcr, ctx_bcr;
> +
> +	/* Setup a context-aware breakpoint */
> +	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> +		  DBGBCR_BT_CTX_LINK;
                               ^^^^^
                          isn't this a regular context-aware breakpoint?
			  the other one is the linked one.

> +	write_dbgbcr(ctx_bp, ctx_bcr);
> +	write_dbgbvr(ctx_bp, ctx);
> +
> +	/* Setup a linked breakpoint (linked to the context-aware breakpoint) */
> +	addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> +		   DBGBCR_BT_ADDR_LINK_CTX |
> +		   ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);

Just a curiosity, can the context-aware one link to this one?

> +	write_dbgbcr(addr_bp, addr_bcr);
> +	write_dbgbvr(addr_bp, addr);
> +	isb();
> +
> +	enable_debug_bwp_exception();
> +}
> +
>  static void install_ss(void)
>  {
>  	uint32_t mdscr;
> @@ -177,8 +204,10 @@ static void install_ss(void)
>  
>  static volatile char write_data;
>  
> -static void guest_code(uint8_t bpn, uint8_t wpn)
> +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
>  {
> +	uint64_t ctx = 0x1;	/* a random context number */

nit: make this number a bit more unlikely to happen by mistake.
I guess you could use all available 32 bits.

> +
>  	GUEST_SYNC(0);
>  
>  	/* Software-breakpoint */
> @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
>  		     : : : "x0");
>  	GUEST_ASSERT_EQ(ss_addr[0], 0);
>  
> +	/* Linked hardware-breakpoint */
> +	hw_bp_addr = 0;
> +	reset_debug_state();
> +	install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
> +	/* Set context id */
> +	write_sysreg(ctx, contextidr_el1);
> +	isb();
> +	asm volatile("hw_bp_ctx: nop");
> +	write_sysreg(0, contextidr_el1);
> +	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
> +
> +	GUEST_SYNC(10);
> +
>  	GUEST_DONE();
>  }
>  
> @@ -327,6 +369,7 @@ int main(int argc, char *argv[])
>  	struct ucall uc;
>  	int stage;
>  	uint64_t aa64dfr0;
> +	uint8_t brps;
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	ucall_init(vm, NULL);
> @@ -349,8 +392,16 @@ int main(int argc, char *argv[])
>  	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
>  				ESR_EC_SVC64, guest_svc_handler);
>  
> -	/* Run tests with breakpoint#0 and watchpoint#0. */
> -	vcpu_args_set(vcpu, 2, 0, 0);
> +	/* Number of breakpoints, minus 1 */
> +	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);

If brps is "number of breakpoints", then there should be a "+ 1" above.
Otherwise brps is really "last breakpoint" (last_brp).

> +	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");

Yes, based on this test, brps is really "last breakpoint". I would
suggest changing the name to "last_brp" (or something similar).

> +
> +	/*
> +	 * Run tests with breakpoint#0 and watchpoint#0, and the higiest

	 * Run tests with breakpoint#0, watchpoint#0, and the highest
	
> +	 * numbered (context-aware) breakpoint.
> +	 */
> +	vcpu_args_set(vcpu, 3, 0, 0, brps);
> +
>  	for (stage = 0; stage < 11; stage++) {
>  		vcpu_run(vcpu);
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
