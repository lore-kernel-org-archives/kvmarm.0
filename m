Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45D217F33
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613815; cv=none; b=aeXjRWRlNg9lgP+ZEKQ/lN87KWXaxi5wuRJ3wrvsyuVl3xf5WkVtDSwCE2I6Ff37di8X0w8hvMfIQwiyuMurdQSP+oeYiYywLYnJbr4nhmG9XC9A1zAaoDTAYGchI/mymqZFqxzg/jP/6kSNvfV/484U1WSCAtnmaM+kNOpVhMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613815; c=relaxed/simple;
	bh=NIZ5AB/YJJK+M4EayGLezVTYifS++JF2plQt5DG/qIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvSh69CLfJetOMCFoLFC86Zsn/3BCxkCC04rdpBtcyrHWac8d2jE4N4MKxkWXfensLn+2FFAE/MhFr8WqoccKYqmFkdEnkGV3Fb206WbH0Y5ifS8/RdbUIaShATqV3uLhmhu3IwAYQscEyp3Ha3lfxfAtf983czW8eORzqRmr3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lHp2D+F1; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHp2D+F1"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-68b90fc6a1dso8712262a12.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 05:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781613812; x=1782218612; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8dPq5z6m1qmF3lfWoJltmjfpShaHtrEx/mXnH1vSGM=;
        b=lHp2D+F1VdiDBZicoLX1WIQfqZJuT8Whr3SGFSWEjl1Ez/gCy1bdCnDzVNjnI8RLRR
         4fgzO3sNlDHilRw0yH1ZIALnjvRp/CRI+XuxamDqPtEDsusT6QHE5pfqVToZo9u/3iH4
         L7ZuI0GUn2zND04uL/B8aw5XvMRGuksvpbzwY/VyM45llMM9PTlN7c2lS+729hcWgKOh
         jHWk1ZHqiwDKn3GKkeCHZaxaVUFPzCXtL+Ycrt/ewrTC9ASeQ5pU3uEO+kUH7pUxZ6om
         vR5DBMdZHF8a9dN6IdylalSxI1vzjlsIHPNR1808B1ov+Qq+/JPsOg7yF+bQO4Np7kbF
         Uwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781613812; x=1782218612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8dPq5z6m1qmF3lfWoJltmjfpShaHtrEx/mXnH1vSGM=;
        b=Azr2tcu2db2JN6GYdBmYlkrasRl5hQMhnqEHcG1Vxi/Vvnn5UidS73+9pjsVQEhPvJ
         BhMZfOxWZYv3k4EQ2cRgkjtMQTuz7NvFGs0lgnsCS66LGm98vqcNksKlciUZrQjp9bp1
         t7FPysGhpvTlyWarpqiJLyPUDiBPJ3xOfgIZP565bmJw/MLGlsBDXoLWLFQ6qKOHBsGs
         1fThkvByA30YXFVQvcIRBuhjoEMAwTvidqwDTFYyS3SXUVLjcE8vHuqYOdoFZ24BLLqd
         dLb7YNsk2moqWJ7L5F6TbJeS9bZ5JVTq2P3n2/nl7BxAh1ENRN2Gj3FpIt+Kse92SjHa
         bI5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+VlTFsNR8Xwg9INtWWF59lSNTZXZS5S5wZHp4DhlfPk/Y4hGuAn6e6gPvutcmEe3Vh39hljS8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy6Clxwn5umnnxqkOvGaJoBFcSQsIgwwMJuPYbx/curxZGi3dR
	c5WFroVMbqQq6vuuE2IcXzzSwRupL5Q8AWfM7yOhmaqPCgh8TcPTE4IJiKRSQwrPIQ==
X-Gm-Gg: Acq92OElIvBKutbhVGbOREeF5cC8nqYhm2fpFwvn0PRiYx0HSrIwsZx+cdSYWRO2+BT
	Jz9lJblbEFaNPAmpJnmhMSC71LqdckiLg4HYhxC75M8VO8lFPoFL+U/InLX3+ejeybzRHSyyeBU
	keYeC82f7JQi6JOTh0DFnbesW+NVZoieZScB2F9nfynilwZ/dloUCMXb2AkjHSdunvj7ZhdMFFt
	z6idbrYF78QmhPuAWib9rDdX/omHkyx3FmBw2dCFop40hSz5y2pHV0oJFmmEpC6a3iDAf1I/sxu
	JicRm382ZzIlchcAUR6JdVF5sqJX/aPCHZiHprWNAMXhlhHYF9TlVpEt1+ZQOjVBlOIyTQfEt4y
	MxtSimTjCaAR18iVmA2n5WAKMoKhOsAwArQPH3Mhci4f2jAABDThSW50ZzNTOMvsUcaxMk/3Dpe
	jsVFW+FxATLLgtDZ35hsjwjikwpX+OdhvTAxLytvLkCcfl1rnnsrBhz2TuqqsltI8UMJVpJFo1I
	TY3Lw==
X-Received: by 2002:aa7:c047:0:b0:68f:9fd9:435a with SMTP id 4fb4d7f45d1cf-69508237df1mr1454321a12.17.1781613811803;
        Tue, 16 Jun 2026 05:43:31 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937938a524sm5008893a12.18.2026.06.16.05.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:43:31 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:43:27 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 2/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_DESTROY in host handler
Message-ID: <ajFE7wrrXcdzXdkI@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-5-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:11AM +0000, Sebastian Ene wrote:
> Allow FF-A notification bitmap destruction messages to be forwarded to
> Trustzone from the host.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index b1e5f9ee86ef..49a43c38a931 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -688,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
> @@ -876,10 +875,12 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
>  				struct kvm_cpu_context *ctxt)
>  {
> +	DECLARE_REG(u32, func_id, ctxt, 0);
>  	DECLARE_REG(u32, vmid, ctxt, 1);
>  	struct arm_smccc_1_2_regs *args;
> +	u32 idx_unused_args = func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2;

Hum, this one applies weirdly too as it's been introduced in the previous patch
already.

>  
> -	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> +	if (ffa_check_unused_args_sbz(ctxt, idx_unused_args)) {
>  		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
>  		return;
>  	}
> @@ -952,6 +953,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
>  	case FFA_NOTIFICATION_BITMAP_CREATE:
> +	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  		do_ffa_notif_bitmap(&res, host_ctxt);
>  		goto out_handled;
>  	}
> -- 
> 2.54.0.1099.g489fc7bff1-goog
> 
