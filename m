Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871928;
	b=qYDqafUTLwLukGI30WEvH2RsoXNKvG5Zb6GGcFh0JuGYhiEbdWRYAz0Yn4g30BJeLQAJ
	 fjNg18uH/uU8ZnylFbkomRqI7oO2Yy0ktwCzSuMisSL5FLnAnFAwu7zCEQ284Sphwlb0K
	 gXBCGcwvt79AmZoJ26jNSUFzPh//sazxYshAm6APXS7R0wOsGPw3mEajV09rW3/ZnpViG
	 dH8D85+iLWtMTTW3tFVcfvBmwaO2mmoDYyXJaeEXuiTu7vFy3dDJd6dF0CIEX8+90h3hd
	 m727V6vUTT18u1zM+IdkSLRSXUmxxOW6dPNH+ZKQCXj6BKSevJNMFC+hFu7YJjGTpzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hI6E0pWdIjYridUcVEtGitpYPVkZ0Czh5YzRDUq6aT8=;
	b=z7UkdeVPMDnrEGKB3/Knl8uqNO8mnvcje2ZeSmJMfXWNZhKmTvbj+CNAHEd4dpWxi/l7
	 oxqHZ/TP+879URm1VZK2hoUWO0HjPAnganhOBaSAf5P2/vWFcVaHDmt+7cGouHVWaJux0
	 md70LmXy3iMzhbpfbB7nPkP+OOh6cUVix+Scjww6EeIRSNR2K/IHQFrSEQ6tqM64W15KL
	 1fXVRqXh3cMxrZdu0Mxj62ILXYzJ6sMUnpFAiYHT+uyYTeVJmcoQ4In51qUAnql3O6vtK
	 X21gn9VC9DLHtgQKkU9WrGWfBiwyETnAh0y+MCJJXT2qvC7qwa3cNPwapiRS+DEhRew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LHOXFIlr;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EEF606A326
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 09:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02EEF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LHOXFIlr
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48fd2e38825so1111108f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Nov 2026 01:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793871925; x=1794476725; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hI6E0pWdIjYridUcVEtGitpYPVkZ0Czh5YzRDUq6aT8=;
        b=LHOXFIlrh30/DqJx/PKINA30gRtrbMjTxhMxjY7GD6vwaruau/jsZWiccQbRUCw27Z
         jowwuO2fsXgLttUKlRwsTmmifXmqbG1EpOQhJR4zuvLy6nOkkeyT2fynw4aUB5zhM379
         0MpbyaPqaNGAQI5N5Q6PpnHO+uZyTsm++ee5oc30Twthqs/MlhvJeAY5b78QS1nNoLvj
         58gpamd3GvLcfSWOuVWfPNgi6QhRkC3al3ZIGPYIFzCQK+T6ggiAFqEQkVEJZi8EaoET
         lMK17jTnDZFs5jUhIavsWtTAXxWUZROgX9NplSFkIdQyHRZfB8Wd+FqUd6mQSYD2hLch
         Qp0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793871925; x=1794476725;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hI6E0pWdIjYridUcVEtGitpYPVkZ0Czh5YzRDUq6aT8=;
        b=kAqm/8Npg3jyQqO7XI7Fl01hvCMAW/BliBElxwho3JoAYgwoC0+UwfusX4vlwRfNZW
         +M+UbE4yaXnMpGaaH7qs87yexb5OI5K8f5Y5jg47dYs4Onj5tpQUHnaYDWN50mt8y6fr
         iZfLikOD87lA8pgZXIuB3FcLd/LNPPZut9UjtOWWNQn+SZU4UxbRXZkSkP6ZsRIU0+5I
         mfOIggUVokHqiUNf8mBVkVfJXlS4PaZdE9rPVhworRejWKRC2Nz+Kv59iMXHJTpdhK6t
         aaxkytqohoyz8pq1TM/J4IJjyfruQK8VqsCC9er2/belbpATS1/f8SSquKDbEVdXsqby
         Kpow==
X-Forwarded-Encrypted: i=1; AKwUvBw322p5XnB5kGgZiwkiMLsN4XBBQ0+a72QtPURZ8oob+1qn5u687QPxlxTondgoVvBUyxkZIAM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9rd2lGThL7wUwUm7P74d5WBVEOo5y7MX0dlnmaqr796SAOW3k+
	aXUhMflzscNXYvOdSEXS9W0KktoU8AosV1ih0Y2FfFlcrBcDxigH8P59eCNh2l1ydw==
X-Gm-Gg: AYBFou2i6+mBiaRTNCkHFrDuZPCZuUtG4aJgzmok2HVr3AxTIQ2fON2zJU+yPneE3Bu
	2UzLiLdEi8N+KI++BLH8KAGo68daOeHueK/x2z0geerDtFemjh4LzqE1gvrb+wzQXH77RuWma6F
	7w7YUpRnXltRVZKiCuhZSgiEBruO9LGPBrAvd07+PpbQnwU9YgToFpri3BW/4dk68497At1t+6U
	K6bcjsxe5Fw73qr96I35fFuctPvepQM9i3OR3oE9t2GDompbKx0WWa+dpX2FUz3yhDJVo6TOEWk
	oADB30Dm3zz4ZgHGg4rzxRvApjZDgrFLyA+lRSrZt78iSoon18XpnT96hSfJhi/fZiwpKidfhAQ
	ZWta5mD+hZh7zx/NaWI+VQokObbnHEpSpMAJK2ft1vnt90SB9Ks0CLPsdGUbkdbuT+OGcbaDpd1
	U5s4h/saD+YxcCR/F6A8gc16s4Wj+37KM0UUD181f5JOVofsFhQRhwPyOpIQW16Zll7J4nQK9p9
	DcITLuT/QFpu03WXBOPbfP3M9rcmYtPRiwfyeN9GuKyaUXIQruBKHQ8sftJMx0Q2SXGr2gyNUnL
	bLbPiZbvX7b57+Y2IaH7iAUfDwmNbC2xFVTLcQGJw2u4om4uSbOVPoIK/DMIx15l
X-Received: by 2002:a05:6000:1842:b0:48e:3cec:b852 with SMTP id ffacd0b85a97d-48e6e500962mr42464044f8f.40.1793871924816;
        Thu, 05 Nov 2026 01:45:24 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece998absm9721233f8f.22.2026.11.05.01.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:45:24 -0800 (PST)
Date: Thu, 5 Nov 2026 09:45:20 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Resume a pKVM stage-2 teardown at the
 next mapping
Message-ID: <auxQMCboC9bhfW7h@google.com>
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
 <20261104124451.2148724-3-fuad.tabba@linux.dev>
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
In-Reply-To: <20261104124451.2148724-3-fuad.tabba@linux.dev>

On Wed, Nov 04, 2026 at 12:44:51PM +0000, Fuad Tabba wrote:
> pKVM keeps a VM's stage-2 mappings in an interval tree, and
> pkvm_pgtable_stage2_destroy_range() releases the ones in its range.
> stage2_destroy_range() still calls it for every block-sized chunk of the
> IPA space. As pKVM gives every VM the host's IPA limit, a teardown with
> LPA2 makes 2^27 calls with 16K pages (2^22 with 4K), however little the
> VM maps.
> 
> Return the address of the next mapping instead, or U64_MAX when none is
> left, so that the teardown skips the space between mappings. No mapping
> crosses a chunk boundary, as pKVM maps at most PMD_SIZE, so the next one
> starts at or above the end of the range. A VM without a handle doesn't
> have anything mapped, so return U64_MAX for it straight away.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/pkvm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index f21c3326dda68..77315c83c61b3 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -504,9 +504,10 @@ u64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +	struct pkvm_mapping *mapping;
>  
>  	if (!handle)
> -		return addr + size;
> +		return U64_MAX;
>  
>  	if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
>  		WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
> @@ -518,7 +519,10 @@ u64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  	else
>  		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  
> -	return addr + size;
> +	/* Mappings left by a failed release are still in the tree, so look past the range. */

Hum, not sure I understand that comment. Which release are we talking about? The
_reclaim or _unshare? If yes, we don't propagate the error and WARN if any of
them fails. So we don't expect any failure here and I'd say there's nothing
special to do?

Additionally, in any case, iter_first(addr + size) seems like the right thing to
do and is self-explanatory.

> +	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr + size, U64_MAX);
> +
> +	return mapping ? gfn_to_gpa(mapping->gfn) : U64_MAX;
>  }
>  
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> -- 
> 2.47.3
> 

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
