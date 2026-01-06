Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B7033893A
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714259; cv=none; b=VTfThJl6XFVmTK9X7rEk6AIW0ABkVsQ5C4Vn5irmkppjnS5XSKeEg0skQCRkB+I40fAapGqXkL6xzWS69lEffKx/P8V2DXvDtLkUgFzlm/WJnJr4sg4UHH3zHaqnhsMKzLrJY7zyFpdt5YDvIrnWKiQVconVNM/V1xmxNJJlqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714259; c=relaxed/simple;
	bh=EYD2kAm5m/G6pF0nu9uuELXRhxz3NqWXXGZ5pAb7I6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQ+byOJSXnh+0uTobnwC50WvgQrVxICK5uZau+FFL+/rHkVK/4JrMsw0q7WQ+E/BoQJxM60X+Kj4kC5Ww5aoYhcDb4dTpQ0P7Ec+ox/5e29SpfO3LnGDBf0LASmz6+BDO9HHbkxNcWvEhYtj4K84vLZxZCwlIT9Jaz1EQplyiZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=At8kZHfP; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="At8kZHfP"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5957db5bdedso1260095e87.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714251; x=1768319051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mz1wbrQcnjuO79QSOtWIYJrTAe9ZLjIXP7SQUWoez/I=;
        b=At8kZHfPLqoXtofMqOjaXdiYV0llsGpMxruwXsyh0s13+8ZR7O5AE1acPbCwtblAuN
         Ppaw8G1hzVP+C+bjY+bgzelVV1eU1OvllxFKwT8ALGI2qSm0Gh0aQ1atkdfE5tlK0QPK
         mVTrJFa0s2JvajBfz6rklQ8LNxBbzFuO9bt2A1EZTdS1XyiuQAlf0JLcGlA8PzXX1FAQ
         cYUuLYbIU+ZGhiIpX7LH1d9D987wE8gOimV0p15YY1XDsg2y7U0TLnB+HWZ2RLS0d1CB
         ZyinVO2ZI2/F6Rfp9m2/Ye7zyxzuhbcYIklUepQ3SjWmQwtxwCbhLaLQqLVjsB1VPYSY
         Aeiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714251; x=1768319051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mz1wbrQcnjuO79QSOtWIYJrTAe9ZLjIXP7SQUWoez/I=;
        b=Jq64hGgB+YgUjBjCl4DK4dKDPU7F9NXGNrBD2xGYqhwlzG6BescU8UNgQ2ak+1ajnQ
         DVx7QNN7/4tgNT+PefYcLkaa98zoVd4UB+Z/9/HXA1NCq4w87sNM1XlD44BM/KE0qxEH
         myfxjhoK7bwppJuGG380r3BowwQelMzNkjusz0fziY5FQuaF7SDgNlDSYx7+amsxa/ij
         39Aso+ZekPfi/BV6kNzgQfMjb6jyLxM/jdNHtIjDMMfm3dpv9XB6SPIRe+99Qm3gohcu
         UCJPfidOtI0j5vpc1opgBI4DecP29fyUU1gXN56q/3o0NKpNVknjRLpO97cPNf6JlV30
         HFIw==
X-Gm-Message-State: AOJu0Yzqp+Nv7okO7hfhngPdBLkjKEV2zvRTljbyfAx5/S8CBARvxY/x
	GSbimi8Fqy5pvKY2Ez8vPl0SnYDsB1xWp7OfCo2D09Ms9M5GMRrA6ZaUjijqmsCRyQ==
X-Gm-Gg: AY/fxX4FCiMs4DucSV0M7RlzHafR2O0xu7Mf49bBofTmfiapqu5Wyl+oN/TIY4I5mVj
	M/+WUDRt8vPtyp+9se0yuo2N7M2O5cpgze3rssqfHWB0k8GJTc7SlvbI63WxA3+LasHn1m6rkXA
	U4WvoFKTsC5LYY4aSMLOZ2ReagmeNPVPhqN21oLE9921Yt3W8RIP12p5HCObKDWISvZIiwJPUsH
	0mZ4UedsOU8/eXpVbopEI8JbfjzypX3eTscRaCWzu5i2jRk8PkohWIi5x+wfx7z1mTGnk7sQDPD
	qmTazdIIJf0rlgpV779A1PNLtp4LwxLfHf0KxddFoLUX5QEqcTZfYF0lYNAf/BV98w+1qqTiI8J
	Z4k0r835Rmvse6F/kLWJaEiCEjjZY9IrwFiH+1PuyMRhWcPhE7YlHGPwCj4JEglUReVCmn7gShE
	06QBJnkhv1PmtDrgUcsmnHVGgbTSWz+66xz9Ur28CmNc3dvL8o
X-Google-Smtp-Source: AGHT+IGkS9tlwTbYGvATESU7hxY01HF7hmBh1v9elXEG0+a5tz+AGtmUgQ/CHKlyCMpkq2RD6my7zw==
X-Received: by 2002:a05:6512:4010:b0:595:8313:3bce with SMTP id 2adb3069b0e04-59b6520ead1mr1016775e87.5.1767714251076;
        Tue, 06 Jan 2026 07:44:11 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65b89842sm649851e87.0.2026.01.06.07.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:44:10 -0800 (PST)
Date: Tue, 6 Jan 2026 15:44:06 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 20/30] KVM: arm64: Introduce hypercall to force reclaim
 of a protected page
Message-ID: <avfs64mpioh4ckdo3gokndinpjdrgfzz2pjhkyyh65v6spuai3@nz4zih4rbv6m>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-21-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-21-will@kernel.org>

> +static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> +				       u64 *gfn)
> +{
> +	pkvm_handle_t handle;
> +	u64 meta;
> +
> +	if (kvm_pte_valid(pte))
> +		return -EINVAL;

Nit:

I can't think of any cases where we'd end up returning -EINVAL here that
isn't indicative of a major problem (e.g taking a stage-2 perm fault we
don't expect) given that we've extensively checked the state of the page
already. Upgrade to WARN()? It's fatal, but the system is unlikely to
make much more progress if we return cleanly anyways, so we might as
well make it obvious where things went wrong.

> +	if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) != PKVM_ID_GUEST)
> +		return -EPERM;
> +
> +	meta = FIELD_GET(KVM_INVALID_PTE_EXTRA_MASK, pte);
> +	handle = FIELD_GET(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, meta);
> +	*vm = get_vm_by_handle(handle);
> +	if (!*vm) {
> +		/* We probably raced with teardown; try again */
> +		return -EAGAIN;
> +	}
> +
> +	*gfn = FIELD_GET(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, meta);
> +	return 0;
> +}
