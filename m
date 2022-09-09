Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A8CECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 19:46:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AABD74C343;
	Fri,  9 Sep 2022 15:46:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mJby19NTNd-v; Fri,  9 Sep 2022 15:46:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C40B4C3AF;
	Fri,  9 Sep 2022 15:46:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C29D4C255
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jg919eZtBjcl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 15:46:09 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B7C24C3A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:46:09 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id e68so2620782pfe.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 12:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=fy5pWO/dRUX6xM2VDhl+XO4wWlv71UbqqZ7Dr8P2NUA=;
 b=ViPw5sYkb0spqLAM8gCth6/doYUXGYy4fRcfdN+cO1RdzfiWj0qoQ1u3zVOaCQOGCh
 T6VyzYaojE6PKNAc1plC2Uwu2judvqKAGj/HWMMlRzntrvbUPYDrE77EvOuqrD762DTc
 D4ij0g9o5A/4+dho8Q2Fk3xT9ZHwHWHhCIKjoaVZt53Nuw40+Be/jW9ld55KVeGz36TI
 uL8Vd9PAOXNI1xBpqtPCejHrkohSq3Vz2GgYb7b/CELaCHjjkEbZKe46dSH+4pGFNOie
 T8718PU9QE1eV5JCgNSol5MQw6LplaBjeLRiDh5vQEqPVUaG5EaaLZgyGmjrsy2bM4VQ
 L2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=fy5pWO/dRUX6xM2VDhl+XO4wWlv71UbqqZ7Dr8P2NUA=;
 b=ZYeF0RMleW2koWRKx3zJ8RjP1PcQefA+nN5WW+3/L4Ymq//McBT1ErkqoA1EHYWqKk
 XlARt5cd9BboTeiIHEavmGdiVbxx9hjHhr3exAMU0uN21ch/YfVShT4lHvJxJThIQWRC
 s6ItMvrN+pGDXh/ENE8drIMXluOFCRk5b/lr0BX+rbLbSea38ufTw5VY+nqSMRUEzt/f
 mX8MOgETB1J7S+aGxgeGSxUPAdrz1Wbyju1jScUv79SkzbV/ndycmsw5T82JSBofTCIx
 07iyP92ri5U81/gTlL5CR8seAN6mvmieLX+InSHJtD4P4QB5jWbUDEXlRVp7PtBhaQHA
 AR8A==
X-Gm-Message-State: ACgBeo1vedmeEqnHn548ht2GWSHVHj9gtE2vlryjtpE0EnLZGlTApKOc
 gVOS1r7g43MKPldWKque9D3Enw==
X-Google-Smtp-Source: AA6agR7ICHnhNhDjiiMWovKWkZt4DZx2eRDlMpU1xfsDqfRWuk5ob3mqzM/bfheJXxlxFxOT1qgPOQ==
X-Received: by 2002:a05:6a00:a04:b0:534:d8a6:40ce with SMTP id
 p4-20020a056a000a0400b00534d8a640cemr15906375pfh.15.1662752767993; 
 Fri, 09 Sep 2022 12:46:07 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 p4-20020a63fe04000000b004388ba7e5a9sm890789pgh.49.2022.09.09.12.46.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 12:46:07 -0700 (PDT)
Date: Fri, 9 Sep 2022 12:46:03 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
Message-ID: <YxuX+ztKm/rPetql@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-4-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-4-reijiw@google.com>
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

On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> Remove the hard-coded {break,watch}point #0 from the guest_code()
> in debug-exceptions to allow {break,watch}point number to be
> specified.  Subsequent patches will add test cases for non-zero
> {break,watch}points.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 51047e6b8db3..183ee16acb7d 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -93,6 +93,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
>  
>  static void reset_debug_state(void)
>  {
> +	uint8_t brps, wrps, i;
> +	uint64_t dfr0;
> +
>  	asm volatile("msr daifset, #8");
>  
>  	write_sysreg(0, osdlr_el1);
> @@ -100,11 +103,20 @@ static void reset_debug_state(void)
>  	isb();
>  
>  	write_sysreg(0, mdscr_el1);
> -	/* This test only uses the first bp and wp slot. */
> -	write_sysreg(0, dbgbvr0_el1);
> -	write_sysreg(0, dbgbcr0_el1);
> -	write_sysreg(0, dbgwcr0_el1);
> -	write_sysreg(0, dbgwvr0_el1);
> +
> +	/* Reset all bcr/bvr/wcr/wvr registers */
> +	dfr0 = read_sysreg(id_aa64dfr0_el1);
> +	brps = cpuid_get_ufield(dfr0, ID_AA64DFR0_BRPS_SHIFT);

I guess this might have to change to ARM64_FEATURE_GET(). In any case:

Reviewed-by: Ricardo Koller <ricarkol@google.com>

(also assuming it includes the commit message clarification about reset
clearing all registers).

> +	for (i = 0; i <= brps; i++) {
> +		write_dbgbcr(i, 0);
> +		write_dbgbvr(i, 0);
> +	}
> +	wrps = cpuid_get_ufield(dfr0, ID_AA64DFR0_WRPS_SHIFT);
> +	for (i = 0; i <= wrps; i++) {
> +		write_dbgwcr(i, 0);
> +		write_dbgwvr(i, 0);
> +	}
> +
>  	isb();
>  }
>  
> @@ -116,14 +128,14 @@ static void enable_os_lock(void)
>  	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
>  }
>  
> -static void install_wp(uint64_t addr)
> +static void install_wp(uint8_t wpn, uint64_t addr)
>  {
>  	uint32_t wcr;
>  	uint32_t mdscr;
>  
>  	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
> -	write_dbgwcr(0, wcr);
> -	write_dbgwvr(0, addr);
> +	write_dbgwcr(wpn, wcr);
> +	write_dbgwvr(wpn, addr);
>  
>  	isb();
>  
> @@ -134,14 +146,14 @@ static void install_wp(uint64_t addr)
>  	isb();
>  }
>  
> -static void install_hw_bp(uint64_t addr)
> +static void install_hw_bp(uint8_t bpn, uint64_t addr)
>  {
>  	uint32_t bcr;
>  	uint32_t mdscr;
>  
>  	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
> -	write_dbgbcr(0, bcr);
> -	write_dbgbvr(0, addr);
> +	write_dbgbcr(bpn, bcr);
> +	write_dbgbvr(bpn, addr);
>  	isb();
>  
>  	asm volatile("msr daifclr, #8");
> @@ -164,7 +176,7 @@ static void install_ss(void)
>  
>  static volatile char write_data;
>  
> -static void guest_code(void)
> +static void guest_code(uint8_t bpn, uint8_t wpn)
>  {
>  	GUEST_SYNC(0);
>  
> @@ -177,7 +189,7 @@ static void guest_code(void)
>  
>  	/* Hardware-breakpoint */
>  	reset_debug_state();
> -	install_hw_bp(PC(hw_bp));
> +	install_hw_bp(bpn, PC(hw_bp));
>  	asm volatile("hw_bp: nop");
>  	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
>  
> @@ -185,7 +197,7 @@ static void guest_code(void)
>  
>  	/* Hardware-breakpoint + svc */
>  	reset_debug_state();
> -	install_hw_bp(PC(bp_svc));
> +	install_hw_bp(bpn, PC(bp_svc));
>  	asm volatile("bp_svc: svc #0");
>  	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
>  	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
> @@ -194,7 +206,7 @@ static void guest_code(void)
>  
>  	/* Hardware-breakpoint + software-breakpoint */
>  	reset_debug_state();
> -	install_hw_bp(PC(bp_brk));
> +	install_hw_bp(bpn, PC(bp_brk));
>  	asm volatile("bp_brk: brk #0");
>  	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
>  	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
> @@ -203,7 +215,7 @@ static void guest_code(void)
>  
>  	/* Watchpoint */
>  	reset_debug_state();
> -	install_wp(PC(write_data));
> +	install_wp(wpn, PC(write_data));
>  	write_data = 'x';
>  	GUEST_ASSERT_EQ(write_data, 'x');
>  	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
> @@ -237,7 +249,7 @@ static void guest_code(void)
>  	/* OS Lock blocking hardware-breakpoint */
>  	reset_debug_state();
>  	enable_os_lock();
> -	install_hw_bp(PC(hw_bp2));
> +	install_hw_bp(bpn, PC(hw_bp2));
>  	hw_bp_addr = 0;
>  	asm volatile("hw_bp2: nop");
>  	GUEST_ASSERT_EQ(hw_bp_addr, 0);
> @@ -249,7 +261,7 @@ static void guest_code(void)
>  	enable_os_lock();
>  	write_data = '\0';
>  	wp_data_addr = 0;
> -	install_wp(PC(write_data));
> +	install_wp(wpn, PC(write_data));
>  	write_data = 'x';
>  	GUEST_ASSERT_EQ(write_data, 'x');
>  	GUEST_ASSERT_EQ(wp_data_addr, 0);
> @@ -337,6 +349,8 @@ int main(int argc, char *argv[])
>  	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
>  				ESR_EC_SVC64, guest_svc_handler);
>  
> +	/* Run tests with breakpoint#0 and watchpoint#0. */
> +	vcpu_args_set(vcpu, 2, 0, 0);
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
