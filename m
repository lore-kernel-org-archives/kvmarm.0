Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243882;
	b=GCTO7d8YY3p302HSUpGjcNif076jNv9+8yCz3OKawzf01/Wv+k5sGFcXUPMdn4V4r/vS
	 Ca0ZkA82+CR5V29iBjptiJ2amHDLQLMxEGiG7KbHELO2LyTE5xcukEL7YAj22JvnzB4TW
	 WfkXW/SsgpJ0Mb3STjQL2RY3IRLn+Nl2QTJnk6VrFZtJeKR0/bWhzu4i95NqtMfAMfPN/
	 4k6mWf7rfvaSd6REl1BMQj/p0/K13tFbfxLj92qam/Hdy4TNIXwR1gWRxCrxjfZg8Vh9J
	 sfLKGuwMpSVzJECC7xp7RyupDk5eR/Wv+8ttAOwZcw6o07csUH0z503+EuxoluqMykg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243882;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+odsCpg7jpRsaCQXSZZ4yxoA+q2K8SnFUpM1JNTaGdM=;
	b=lIjAKru5SGVbLsfdFfaVYEtWd/BlZGLJ4dAtW/cQU6jbXfiKmfsSxqU8bnPB/6L554fu
	 eTJ+iqSw+/hS19+DqgDuA6YQDtM6lrmEcrxexycuSQflma2uY/pleoNitT6plR825Zg2T
	 C+co9r90BQXupSEdVcYC/jaYNlHMiJy/wFnWYXuHgrXdPXOl7yM/sYbwneiPC6GSL9JyG
	 ecSt8zu5bM0WQQvFvfLbfDdBckx8Slm2eZOVQAy4TNtuZHAd4GaXvjHxO7w1tLB1OBo9v
	 JuXQy4Bc66wYjl0k7Bl+cEXrkSPGO9DppmO/qF92cdP7rgDvHJ4UVqvdCdeNEQDqGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FODMQ6HF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC6606A339;
	Mon,  9 Nov 2026 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FODMQ6HF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A7D1F008A1;
	Mon,  9 Nov 2026 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243881;
	bh=+odsCpg7jpRsaCQXSZZ4yxoA+q2K8SnFUpM1JNTaGdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FODMQ6HFrJPYbAiPnyWZS0/BhpGp22hllkW0FNfkoaK5CcC043UUfohcKcPk1gp16
	 +9rUSS5AA4O8P+dEykIPa8fswmqGJ0vYl2zVPKtNbC1dNy1YVwUbtIWWghnDLkPv4H
	 pfEuNOOx7qWMEfr3GxEDV18r56z+KZxWptqV+Z2+Ei9UoN4dbxPH9IMVswH7Fcd9ST
	 0kAiW09cm9cSKYdVE6hlg0yi5Uu18PRtwm/TOXAHJEMGfMP2/T5bBWkDZaG2hYpECf
	 JMe7NL5gOG3nRzUWGmhVvmYoVpBL3PYjuULhStALMsZ/6RHe4Yfzy1/B7YEbUsb+YW
	 e4jLSkMwebdeA==
Date: Mon, 9 Nov 2026 09:04:40 -0800
From: Oliver Upton <oupton@kernel.org>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, maz@kernel.org, fuad.tabba@linux.dev,
	yuzenghui@huawei.com, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, liuyonglong@huawei.com,
	wangzhou1@hisilicon.com, prime.zeng@hisilicon.com,
	tangchengchang@huawei.com, zhengtian10@huawei.com,
	linuxarm@huawei.com, liujian222@huawei.com
Subject: Re: [PATCH] KVM: arm64: Register irq_bypass consumers only with GICv4
Message-ID: <avH9KJ99im5Z2wEb@kernel.org>
References: <20261109112018.241298-1-yangjinqian1@huawei.com>
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
In-Reply-To: <20261109112018.241298-1-yangjinqian1@huawei.com>

Hi,

On Mon, Nov 09, 2026 at 07:20:18PM +0800, Jinqian Yang wrote:
> kvm_arch_has_irq_bypass() on arm64 returns true unconditionally, so
> every irqfd assignment registers an irq_bypass consumer even when the
> hardware cannot perform GICv4 direct MSI forwarding. In that case
> kvm_vgic_v4_set_forwarding() bails out at its very first check, since
> vgic_supports_direct_msis() is false without has_gicv4, and the
> registration becomes pure overhead: every KVM_IRQFD ioctl takes the
> global irq_bypass mutex, which becomes a contention point when many
> VMs boot concurrently.
> 
> Gate the registration on kvm_vgic_global_state.has_gicv4, the way x86
> gates on enable_device_posted_irqs. Functionally this is a no-op:
> without GICv4 the consumer registration never did anything beyond
> acquiring the lock.  On a GICv3-only host booting 100 microVMs
> concurrently this cuts the average boot time by ~5 ms, matching the
> gain observed with CONFIG_HAVE_KVM_IRQ_BYPASS=n.
> 
> Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 97332ffcb130..785d57388032 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1744,7 +1744,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  
>  static inline bool kvm_arch_has_irq_bypass(void)
>  {
> -	return true;
> +	return kvm_vgic_global_state.has_gicv4;
>  }

This should just take a pointer on struct kvm then use
vgic_supports_direct_msis() since having an initialized irqchip is a
precondition of kvm_irqfd_assign().

Thanks,
Oliver
