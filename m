Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7D1F4C85
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749473672; cv=none; b=OxJRM3Gh75uiuH4KLXcPIZoaj7qQBt0Xck6ttBpwLdZzmRI/bu/M0KG954iTu35QOft/DoIXRDej3TiQeZfq7G1SJAnLbGYWR+kVgce+isofrQPBrE9ZgDRo+z217e8+78cupyJoyjCrsGYd+I8ns+58YuN4BeqnemYn1vu+UwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749473672; c=relaxed/simple;
	bh=g0lqbFBPc8O9RqKPPbnkwDW7qPXz8SjHCy9PsChiGDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRUEviP2LZXg0Bd77yIOvhZIfbls4NFMt6mbaH8mAc5cAESAeLwDej8Dzf1pXaUjN7C7YgPCPUV+5jpXRNTpuNFnsu3k8kB7fXooeuiSk8ZqKiSRA5CSpSbQIyzkTmOBNqnDreovu9jvpV9AYeuIglJcRmDTh1ptg8acghn6MMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EHb04vkp; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EHb04vkp"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a54836cb7fso698492f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749473669; x=1750078469; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xB2zG2k1G4WQxpgsH4LuYksFLvv8C8C4QIYaKBnq/b4=;
        b=EHb04vkpsnq8Fup1ussGxXgDPWq2mR+12s8XJeN6q/enhDVATCYLAbqfjKQT6xBqBL
         dmFOZr7KduaSI73lGb8hRWvyAW4UwB1e9BKpy89p1Tcn4r3i4d01vzTdujJuErJG9AyF
         izHNEjle9ow7O5L3devyNJsdN9IfZR9Fpo8iqVERt8TS/pBhD8Gr3l+2ahe5Nz9TdaSf
         9syYOwllHcvS4aUER2CX2kQxYfoUFejXhHJbpO3P0zZ58UqEt7PBi/EG7LX1uPllKDBo
         0Q+93jXxjj/Ek5qH05dXJsw8EXgyxdnbPU/oO1xKGzCahv+2Q0/OMNewaWSTfwzEUI7w
         Cbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749473669; x=1750078469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xB2zG2k1G4WQxpgsH4LuYksFLvv8C8C4QIYaKBnq/b4=;
        b=p+MZGtQ0zNIu7V/cFwYafVsETKsLf5m/HX3vvkuo4KgfmVnaY4gaHgrmMMSH3hAqMS
         SRxDhjQ+WHtSxTYVZnU6quFhL71Lx2hTkZdTg5BjBKZxTh4xcstwnnCgS5eiZ1AmpehR
         rjupS5SsUjUZd8DVRBL2f5WBxpSHG+bNK4Z8qhi4zF0WX+7XBAvIwGXTnsT0tDH5vbzL
         i45kcmINKgXPghO7gk7O0b7hni8LQWqJWxAQd2Gonx1Chfo1kcjEPI5LyNBhzGNpGGU2
         jUEmAnw6Y5h6SuxW/Mu4rBpRIO8XgXPh6RE8Uz+jM7zhq5Cfyzw/cuZ2cFUkSYIgvieT
         lEUg==
X-Forwarded-Encrypted: i=1; AJvYcCWTJS7A4Bqum2+nQwQktZGOVEOYMPJy+Gzm0gpQDUOFKKoqRdtMuQgw/JP4XGPoXRp4PVMG9nw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMW99IN8CruXsxH0Yg6XRA7N887iF83Zpe73GLi88+rKUWyfuv
	vZqOfmwtzLnE4ikD1472Ed+SkPj6ZWcGCcO0YNKV9eP8z0MQKQBI0ycKDN+5i21nU58=
X-Gm-Gg: ASbGncsBcFJbpfXJfw9fdeySEB9DvFFvmP0tD6OujAnQCBZdAiD4TLapIlvOuC2Vh8F
	nkXl+nlh1KX+9dv/jtYSVGlavoBpLFm+Pfyph2w9RRJ88dbIMygdZBkdAV0FaseRua19lJUoF3C
	t0nxsjJmBxEqtkQteH9qCRxXZQrepQRPfVc4fXztiDVmM8gYFWs5CqBIx9h4oThxTRKtUGEynMb
	+7mIbJtYNam3auHyCMO7OPXKFx3IXoDdKF5GeltZifwVeafcUrpbgeKKWKhTVzSc0o+vtlzwAcH
	ZFB7rgrT5nAlsCOWVg23MA4x5Y5Ro4zULuc2e8YExNJTjKBaHg==
X-Google-Smtp-Source: AGHT+IEC/1dBxgIFgGAmnWpdiKwEZouvKkkuBZf9Ps4mzSz9CyCY930v5yHNcYS1Azk34Z4raHel5g==
X-Received: by 2002:a5d:5f94:0:b0:3a4:eecf:b8cb with SMTP id ffacd0b85a97d-3a5318a7648mr10575693f8f.28.1749473668526;
        Mon, 09 Jun 2025 05:54:28 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::2f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4530748870bsm62109445e9.33.2025.06.09.05.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 05:54:28 -0700 (PDT)
Date: Mon, 9 Jun 2025 14:54:27 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, anup@brainfault.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Subject: Re: [PATCH v2 15/15] KVM: selftests: Add riscv auto generated test
 files for KVM Selftests Runner
Message-ID: <20250609-cb3c80fbe1fe702668830b1b@orel>
References: <20250606235619.1841595-1-vipinsh@google.com>
 <20250606235619.1841595-16-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606235619.1841595-16-vipinsh@google.com>

On Fri, Jun 06, 2025 at 04:56:19PM -0700, Vipin Sharma wrote:
> Add auto generated test files for s390 platforms.
                                    ^ riscv

Thanks,
drew

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test | 1 +
>  .../testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test  | 1 +
>  2 files changed, 2 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
>  create mode 100644 tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> 
> diff --git a/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
> new file mode 100644
> index 000000000000..d34b4b9b77ae
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
> @@ -0,0 +1 @@
> +riscv/ebreak_test
> diff --git a/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> new file mode 100644
> index 000000000000..5abb62c51097
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
> @@ -0,0 +1 @@
> +riscv/sbi_pmu_test
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
