Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793099124;
	b=32KBh8Lu65JR5cBdojscwMmRq8zcH40k1Xxrd8yo3QKfInWommXfM34ljJoC3RtX9cJ4
	 2B3W9AQrBBe0X6ofOnPH4AIIbBpaZysvuxfqwoL74vGASBID6GM87UsNSiJDSe4WFCoCX
	 5YKh0xpFkNmuvqvAPEg4Bd3mcQyQiS3U7qdahqCmR2Gbheg8bxaL+y7MkW/VuvY0bxvuu
	 872BqeNGQQVpjCjq7oqJDj904PE7V0N5ywqg9ha6TY6S0LKPDZtkf3NdcHgeSH7fnmmAH
	 ac/98XYcHYbogVboJz/Ls/f7EVt8VNOEcEg9PHPEIgq/K5zEOGSqAUX+rd4axPiQmMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=2O75Mv2XtxZlV4hudBgTA9FuTJanexSJUKv97fAgems=;
	b=GoIZwFYcTtSEB9wUgBcchjcMWr3gn6TSKx4dsxnvOck0XJQBUb/lI2/2tg6lLRc2MAa/
	 rI1hL6/lv2SPcZcmR/mBuqvi1NfW5sqi3kRsbjl1SJAZE8TEsm9q2wQ1DecRsRACu4uB1
	 fhjBGg+kQAl2aD/lChKT5//RM7Khk5p4K9g9ES5EclDPfbcUw1mq3SF66DZj+l4an3MuH
	 hIbjouWOsTEi6iPrAJqGL8+/CZT8ksa/i7slbFvSW8q0tHt413k0XJg7sYUTOl4YfSGL/
	 gNgAyUCwYy2Mozo1G3CYkYlzpYPO2plKhwdtZqzjrRttpI4yDjgiafyXjmWK9uAqC2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YmkhKPbt;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B440C606A31B
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 11:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B440C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YmkhKPbt
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1977872f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 04:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793099122; x=1793703922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2O75Mv2XtxZlV4hudBgTA9FuTJanexSJUKv97fAgems=;
        b=YmkhKPbttvto68L41WFdFvhjopH3OrxpKl1h3OFtSfUX7lQUNyqOgt/ry5CRtVnMW/
         7O4jezlf8InPHl0UPZGSb7DKs7Dl2HhJmpnhEM8nkXQAEYtODozXRBX7CNHVk+9VH3HT
         sHwjTsdMVb9RdqZMY8sOMEyEqTsRgcJ/lJff3eK5JYe2FdLQwT+eevGxcBTGQlTxR88h
         boryifwrYGo8uJeb+THS++nYKHuIYa2oYA5an5w2W+WEwAc1BTRD2PF0hhTF0R3zVzbM
         gGoymU4q3CcxnGUn3FY5pNnpQSvXb676S0kacSyANJlJHeVpE3mDE78qZA+2xn7nCVdz
         pS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793099122; x=1793703922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2O75Mv2XtxZlV4hudBgTA9FuTJanexSJUKv97fAgems=;
        b=EMxSb0dXxZ4l5h4vfyiVPMpf7LYEV7nfguoZLpCYIXqGX/03W96fAEQSMne9nw/D8d
         zgNw0RnApuIWA8fYYhOdsSW+vf2Rq26RfGcmpNlB7diE6f4NuyYEtDAU3GDWjjB9H/+h
         iZ02W//LqF7Lgoy6ip/aZkXhHBvrkSA0SyUCMQ0U5oYXqYQSsFlBZuzYgnTyZ3F7AGD3
         /oxMrMpGahX7wnfgdC7ETeeWX5zeTiwDU3Z/fiT/Tb/irKqfwlb+UcDXh8tWyLinVaSX
         u5lF4lX0z2OJkeAq4Pbd+h6QTv3UDs89g9I/1lKo8dpZ7jhuE+tIPW6j4kp2d7a9McyZ
         gSOA==
X-Forwarded-Encrypted: i=1; AKwUvBy8bBPeN65EgZEzQdiK3ooBPSNs+iZm4ZGt6qlZDgYMU7srkLoQg/Vbd1yBQ+Pxb2I9VQi1jYc=@lists.linux.dev
X-Gm-Message-State: AFq9FYIfXZVvNLLu5HZbKImHVh4HPtaXURT+eQtA9GP+F07/1mcFBam+
	GwoBTjVTdsRnaKTrJqocshZ1qrm1Jxc4OpGGA1vq6twFQqYQZra652Oav2WBGZ89gA==
X-Gm-Gg: AYBFou2m2NdAkQnGbRGxcId6gtx9wdWXSDKMzTm3w9g0hYkWhFgyuNvL7TddKHNqUMb
	3eYOtcsCp9mD7aqBE0P8T3l1SZLiRCj7vawkIJS3M97qeOX6kX01b8fjnmUf93g5KzUie1q2A1Q
	hCkWYZXFl2Cdd7ZpVzJz3AJttvw0BLLlzPrEjcBcNo9186YcuVwiEVvFnAClFvdcQ5Obr8ZKGXL
	P2/pQ2cX170no2rpYoeVvYyIRPFYhvVtyKk627/UjcqQBvXzhopOUfo87TUSNWA2wIHxnoCpMpQ
	m5xU32wiwNn3i+FOqqFTosYrvYPaB79N9+8/kW+80u8ARv30JFybuoCRhBiZwqyEaOvVFlFCKK4
	sgqvzLA5qz2LyJxbSBnm4Xqep+yLF9zqVuBbcI2lcC4N48maJ+CbJXJ8NWLgCLhnaXsCU/Pt1dk
	vbnEUYo/5ivZ1CNmNjVidf+5fYX2JMAW5XdUPflw2wxcXvgoX3MrzFo41a/bBdDSJEQ5ZU/ovEG
	NYAGHCRl7dRqhTwwUFhQIOzmClLzi137/bmz9RGRFd2t3teiqRQXl90mbnmXhPTc0IBkWTq5Hzo
	HWcNPv8v0hyOzQ/yKM9uXFvq9WAxbbooC+oo3A==
X-Received: by 2002:a05:600c:4f0f:b0:4a1:acaa:c355 with SMTP id 5b1f17b1804b1-4a35ac803e2mr215293275e9.10.1793099121225;
        Tue, 27 Oct 2026 04:05:21 -0700 (PDT)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359f59750sm174413535e9.0.2026.10.27.04.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:05:20 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:05:15 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kernel-team@android.com, linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Pass the PMU events to the hyp vCPU of
 non-protected guests
Message-ID: <auCFa2VPEmxx2ZcC@google.com>
References: <20261027081147.498183-1-fuad.tabba@linux.dev>
 <20261027081147.498183-3-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027081147.498183-3-fuad.tabba@linux.dev>

On Tue, Oct 27, 2026 at 08:11:46AM +0000, Fuad Tabba wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> Before every run, the host records in vcpu->arch.pmu.events which perf
> counters to disable and enable around guest entry, and
> __pmu_switch_to_guest() applies them at EL2. Since commit be66e67f1750
> ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()"),
> protected mode runs the hyp vCPU instead, and flush_hyp_vcpu() never
> copies the events into it. So the counters backing a non-protected
> guest's PMU are never enabled, and every counter the guest reads stays
> at 0, the cycle counter included. The host's counters that exclude
> guests keep counting the guest as well.
> 
> Copy the events into the hyp vCPU of a non-protected guest on every run.
> The events only exist with CONFIG_HW_PERF_EVENTS, so the copy is built
> under it. Like mdcr_el2, they're host-controlled and never reach a
> protected guest.
> 
> Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
> Link: https://lore.kernel.org/all/20240305184840.636212-2-oliver.upton@linux.dev/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> [Fuad: non-protected copy only, tested on the hyp vCPU, under
>  CONFIG_HW_PERF_EVENTS, new message]
> Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index d715aa942577e..28a292deecb64 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -690,6 +690,16 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  		host_vcpu->arch.external_debug_state = hyp_vcpu->vcpu.arch.external_debug_state;
>  }
>  
> +#ifdef CONFIG_HW_PERF_EVENTS
> +static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		hyp_vcpu->vcpu.arch.pmu.events = hyp_vcpu->host_vcpu->arch.pmu.events;
> +}
> +#else
> +static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu) {}
> +#endif

nit: Could save a couple of lines by just doing?

#ifdef CONFIG_HW_PERF_EVENTS
   if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
        hyp_vcpu->vcpu.arch.pmu.events = hyp_vcpu->host_vcpu->arch.pmu.events;
#endif

> +
>  static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> @@ -698,6 +708,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  
>  	fpsimd_sve_flush();
>  	flush_debug_state(hyp_vcpu);
> +	flush_pmu_state(hyp_vcpu);
>  
>  	/*
>  	 * If we deal with a non-protected guest and the state is potentially
> -- 
> 2.47.3
> 

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
