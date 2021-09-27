Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30D5C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:32:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29B4E60F92
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29B4E60F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C234B0BA;
	Mon, 27 Sep 2021 12:32:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RKhTxY0ldfOz; Mon, 27 Sep 2021 12:32:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 833014B08A;
	Mon, 27 Sep 2021 12:32:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C671B4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:32:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjcqfPhBWw47 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 12:32:13 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8941740C88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:32:13 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id t8so53080411wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 09:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sDm0X5qQPferwq6fv+ku/0Jsg062MnSmwsDAd1S9+ac=;
 b=gGwDEcPz9HLzaQCAI7q3j4o5mViGJZZaCFUHWm+LGKKIWsJnbNfUOuirDv9dCdi6DC
 q+EzRoJzs8owpT/noKmfYmdMYftJd+hO9RgGv4Ti5mip4+SPxvq85IWvAPZkrzgv85Qu
 HQPKsfQ71rr7WuEzqtGV4az3nA6/UUhEACkdoVHLXF46X2A5J9SaU62v0MtY988HfyRm
 v0RnGY1SaQMamGv0t41roAMyiOso7/1NX3selVMrSbvvL2NLJc9rxYSfzx2QUGthc6L+
 GsRdVMkJ4wrO53K4bTiFMki4C9BQxEPKGSOowkMQCiYCGJu4y2wEyUdsPoql1FTdwg4u
 +o8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sDm0X5qQPferwq6fv+ku/0Jsg062MnSmwsDAd1S9+ac=;
 b=d4CPj3zmAs0E/dkrq90vYgE5goKccRC2KbALVRouHgrNXGe7SPW7/yl7QkWMAhW0Ry
 Q6BLmOG4YK2mQo9lmPeGjegFPr7hx9rV2lERqxEb/MCDMv+d4Q6C6X+n1+pk2WqpcKq8
 PWUzpNFmdnUsGJpf7psao+nRh+3K2Cxa2pMtr0ck6LxHLtub1rrMlj3qHgZcNSDHdBi6
 G+m4y+Z5i0YGmEGFB085QyE2LYLqqK9+5kGZzeMPMrBj3WXXEsj6LUCnmBQXWhd4qTzW
 2ogFylJn85LVontp80JijdtKtxs0GLxV2PuZcjo72uWq58czbVx0q4go3iodxvm+QxRX
 tA1g==
X-Gm-Message-State: AOAM531tkkVcE6z6VYWv53v5T+GdmTX4kAkfeEN8oPK8key2R+gFUcvS
 ViRkMkXzVrP+grobENI8VBs/cQ==
X-Google-Smtp-Source: ABdhPJz+nq3KlBHGIoypjiRXZpcfjyQ1XRIJV9AK88Ba7/gCIYfpf+eVqswPyUj0b+aAtePsXm96tg==
X-Received: by 2002:adf:8b52:: with SMTP id v18mr875658wra.1.1632760332278;
 Mon, 27 Sep 2021 09:32:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
 by smtp.gmail.com with ESMTPSA id j21sm18107813wmj.40.2021.09.27.09.32.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 09:32:12 -0700 (PDT)
Date: Mon, 27 Sep 2021 17:32:09 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v1 11/30] KVM: arm64: create and use a new
 vcpu_hyp_state struct
Message-ID: <YVHyCW+D0M3U2Llu@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-12-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-12-tabba@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Friday 24 Sep 2021 at 13:53:40 (+0100), Fuad Tabba wrote:
> Create a struct for the hypervisor state from the related fields
> in vcpu_arch. This is needed in future patches to reduce the
> scope of functions from the vcpu as a whole to only the relevant
> state, via this newly created struct.
> 
> Create a new instance of this struct in vcpu_arch and fix the
> accessors to use the new fields. Remove the existing fields from
> vcpu_arch.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++-------------
>  arch/arm64/kernel/asm-offsets.c   |  2 +-
>  2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e5c173d2360..dc4b5e133d86 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -269,27 +269,35 @@ struct vcpu_reset_state {
>  	bool		reset;
>  };
>  
> +/* Holds the hyp-relevant data of a vcpu.*/
> +struct vcpu_hyp_state {
> +	/* HYP configuration */
> +	u64 hcr_el2;
> +	u32 mdcr_el2;
> +
> +	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> +	u64 vsesr_el2;
> +
> +	/* Exception Information */
> +	struct kvm_vcpu_fault_info fault;
> +
> +	/* Miscellaneous vcpu state flags */
> +	u64 flags;
> +};
> +
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
>  	void *sve_state;
>  	unsigned int sve_max_vl;
>  
> +	struct vcpu_hyp_state hyp_state;
> +
>  	/* Stage 2 paging state used by the hardware on next switch */
>  	struct kvm_s2_mmu *hw_mmu;
>  
> -	/* HYP configuration */
> -	u64 hcr_el2;
> -	u32 mdcr_el2;
> -
> -	/* Exception Information */
> -	struct kvm_vcpu_fault_info fault;
> -
>  	/* State of various workarounds, see kvm_asm.h for bit assignment */
>  	u64 workaround_flags;
>  
> -	/* Miscellaneous vcpu state flags */
> -	u64 flags;
> -
>  	/*
>  	 * We maintain more than a single set of debug registers to support
>  	 * debugging the guest from the host and to maintain separate host and
> @@ -356,9 +364,6 @@ struct kvm_vcpu_arch {
>  	/* Detect first run of a vcpu */
>  	bool has_run_once;
>  
> -	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> -	u64 vsesr_el2;
> -
>  	/* Additional reset state */
>  	struct vcpu_reset_state	reset_state;
>  
> @@ -373,7 +378,7 @@ struct kvm_vcpu_arch {
>  	} steal;
>  };
>  
> -#define hyp_state(vcpu) ((vcpu)->arch)
> +#define hyp_state(vcpu) ((vcpu)->arch.hyp_state)

Aha, so _that_ is the nice thing about the previous patches ... I need
to stare at this series for a little longer, but wouldn't it be easier
to simply apply the struct kvm_vcpu_arch change and fixup all the users
at once instead of having all these preparatory patches? It's probably
personal preference at this point, but I must admit I'm finding all
these layers of accessors a little confusing. Happy to hear what others
think.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
