Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D92435A93
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785177349; cv=none; b=eeGFvSNPckQnpAcfejHDF2oVzSUSfFPo2D9e507tcGrL1DkKsOOYqu56CJ3EYYk7tQnZS4jYyMahse9FjwzbNBPVx+6+OM/4l/Ybx2OisNxoAtcbwmM4zla6NVA87ynl8XO5+NsRe2LV4M0+gUF7oz5JkCDeehJn5vl7/FOZ8kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785177349; c=relaxed/simple;
	bh=XFyYhXTeik54B4fcoKahFoRLBKApUvIC1kXaWZowbc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KrpGdVgzp8s2UV4yP9dA3+9MrSKumPKxH4cAEMqqvG4Jj+WpCVMPJOhBoazz/2PmbDR4SwbLNb5vCQxR3aJqhyryQiSVB9PT+2EiVEZrWAgvxyGp94cu7k+8i2w0bWKNXkGLbiii8pdgwtur33JGgxUM8b/oNYbSPK0Cnbqw0Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XFsjlrMz; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XFsjlrMz"
X-Forwarded-Encrypted: i=1; AHgh+Rrkev8KY8L+AeJUX8cnetWpfGJv4ZtKD1OwMsfgcx3jTGXXeL6NYGxEXTR4dFMvTcd5bnIYKSA=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785177345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KwsttPieEvyPrTGKzEYr9m1Cr8j+zwTvS+cA4oapoyo=;
	b=XFsjlrMz1WF38Vfzvkn7ERQg1vXOiGH42SynqwMHNRONi8GxMysg1b7FhkiSPrMr+y5jfi
	3tZeaIKg/yGLL7ImDGdW6yz4UleybfcXnJT0vuHc/X3tSsHdE7YEu1qxlVMHeVoS5mq5/K
	EMf7uCs9hkRnB2T8Sdum0FYIaJ1/8sA=
X-Gm-Message-State: AOJu0YwfRGUP8gAs8YKSy4L/2P0Ny77pxed2eRTuHXzJjcrj6ZvP81o/
	PBVBY8osqqjUeUv0XDjk83KsV1WTrS6KxHGYzq0R54EExn4xbaswmA6xMVcFVhkxs8yNyQeh22n
	PKtIpIw2ywDZWHCJy1ZAr0oWMveStNNi94FOGTk7B
X-Received: by 2002:a05:622a:354:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-529a5f15b56mr40755811cf.8.1785177335476; Mon, 27 Jul 2026
 11:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260724104819.1296803-1-sascha.bischoff@arm.com> <20260724104819.1296803-21-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-21-sascha.bischoff@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 27 Jul 2026 19:34:58 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxtSGHO__O6V+Km+3f5ASJepA=5cVHs8BdjJoLbRwbLpg@mail.gmail.com>
X-Gm-Features: AUfX_mxf8D38n9yuNlqRG7bxJInR1aSDZxlbsMy4SmN-tvZfAPBS-ChXFUbS8uQ
Message-ID: <CA+EHjTxtSGHO__O6V+Km+3f5ASJepA=5cVHs8BdjJoLbRwbLpg@mail.gmail.com>
Subject: Re: [PATCH v4 20/48] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sascha,

On Fri, 24 Jul 2026 at 11:54, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
...

> +       case GICV5_IRS_IDR1:
> +               value = FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
> +                                  atomic_read(&vcpu->kvm->online_vcpus));
> +               /*
> +                * IRS_IDR1 encodes IAFFID_BITS as N - 1.
> +                */
> +               vpe_id_bits = vgic_v5_vmte_vpe_id_bits(vcpu);
> +               value |= FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);

I think the advertised IAFFID width might not cover the IAFFIDs KVM hands out.

vgic_v5_vmte_vpe_id_bits() sizes the VPE ID space from the vCPU count,
but the IAFFID a guest reads from ICC_IAFFIDR_EL1 is vcpu_id, which
userspace picks. Two vCPUs created with IDs 0 and 300 give an
IAFFID_BITS of one implemented bit, with the second vCPU reporting
300. I could not find anything in the spec requiring the reported
IAFFID to fit the advertised width, but to be sufficient to identify
every PE in the system if my read is correct.

Cheers,
/fuad
