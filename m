Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF848633F
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 19:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733860008; cv=none; b=UX0BT1DHoxWf+ztsKWtpJJ1Tyt91HpQLPqvFfm/qAfSiLeTihiWwBIzBP/JRAnQyVNcJVsefqyR59IiGuwZz1qHkDKpjjTMfeEypVTETKT4ZdPDmD0OMlU2neO/waVBfnVu38yy7Jw1R3YsZH/5cDHN9UATHdc1uwAYspk+k1ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733860008; c=relaxed/simple;
	bh=n8zO3jKoyxsj6HbTi05UzzHpPoCA3MPc6h5O6atmL3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TksuccO/5FxjV6xM2UNUTE4EiaiuKua90drO2LB6vCFLh0w4FfR4HPEvkRBwpOcnOh7s5ZVa1m2p0d6wYnb46DJ3r0OWCMwULcE0PX/arEfZUqvmi0mfkjxJCy7iuyHApBPgx9p8uW/UiHcGw82Iv4NSg1vuA9EuYUlr7Cn0V4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Rkunz/0; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Rkunz/0"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso893238966b.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 11:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733860005; x=1734464805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A0dTmTZsOI9hQmaca48zwWtaCXiY2ZalD73VTkV/Wfc=;
        b=4Rkunz/0n7XDRiNAhqvOLMRgu42IVPlCpLo7wAocdTCJS0MZ6x0FVgeOFOEEBwhGnC
         y4MSzVChBsR2Z6LhfbmBYIsUgKvXi7do7qIqay45vwWpwqeDxr9AbRtptOGTuDEjGI0n
         1znzNoZSbZy7nmJKmz5IrxeiLkyW8aBJOV8YIL97AH8UZuLorS5D26odtXZX56mup48+
         h6n2o2ph4zSLxmd5qRO0nkey8SSVkK2a9FCj3Ubf7NvLcFPN6HNeGyFADYBZ0Sk55kWF
         RHqRQSm3NR1WoGroClTcUPeNALW9RW2YW4mOP/wUa6TymgmcIMR4FuD9MYcY6ynjkWOZ
         A5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733860005; x=1734464805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0dTmTZsOI9hQmaca48zwWtaCXiY2ZalD73VTkV/Wfc=;
        b=T9GVUodGfXETZDtPa5feY6kQh8LCBGOPLpDtwbvDuLyMl4pHniiJ1bQ6zRPwJ3Ln9o
         Uo7764FFRvRNxEbFJnCjo5gdaY4jCsfQUfFY6/rRDjUc+Qcf+Zd533dCF63z2B0CElR2
         Tz9eJ2+ml20jjy04RJNmL4sVJl9rMzSZIfG43RPTN0a57Os0K4tBHqIHFZxhbVYi6sDQ
         VJ6wTuHcN9BAQ4ZUq92BGRmg4AglHDQvg73fHUBJ4DIO/vRplOKXDbI8flTwli6wB9OU
         dxebM71V1XQlv+BSd2Muaye+ZvQLnCCJSpDO1a6F3g4QNLVNf9ZluHhMyWG5+lbjp/qt
         y8DA==
X-Forwarded-Encrypted: i=1; AJvYcCWaszy0eG9BkgEbMeP20bsfQULm6eCUe9sjWoLq/ZGs3RSaQsDhpP7JVdp8knUsLzW9UFjGJDE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxf3NGe9ZjfQuVaNQcrH9Kt/S2k3KfoWrLZK8dYg0ilt4S5FLFm
	NbRqGN5cvX3rRNzE/qf6wobseDH8tPX9sf5Sgv7kiMzHqh8oblyoYxEpaurCJg==
X-Gm-Gg: ASbGncuNsh96EE1rFMKO09IpD8YEm9Es1QkLw4ZIXeqQBU8JDslzCXRPumnYdK/WiGX
	ksatALQhgBZ6BDOjC9hGaBPMUjgSdhVNDjJG3bIPIOTlwSjkf8YpuKaIFUMBFPudzzDlU/PGKN4
	eXYRlJpKmoeYDrIj/dCosKbEcmxLUkmgY+bYkWfmcGifyEWXM8sQad3GUtvY3KYgxchNfOwpgUy
	8JrYPF8hhUTxykEP3PEU61cmqneJxSJtj96sODDnyuuxGs9bCugX67xODOthD4NVxZq8oEv1k6N
	UHtR+lktfA1I
X-Google-Smtp-Source: AGHT+IF8OXUsJlvVq2WfJtUgUFxuNR6rqta58L0bNZagCkPdnarHQO7ASCTfCCHZ8UICmUNDGta8LQ==
X-Received: by 2002:a17:907:7819:b0:aa6:ac19:b579 with SMTP id a640c23a62f3a-aa6b11eb111mr4655566b.26.1733860004764;
        Tue, 10 Dec 2024 11:46:44 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa692e4e9d5sm296409866b.129.2024.12.10.11.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 11:46:44 -0800 (PST)
Date: Tue, 10 Dec 2024 19:46:41 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/18] KVM: arm64: Introduce
 __pkvm_host_mkyoung_guest()
Message-ID: <Z1iaof2DgZfZxc4l@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-16-qperret@google.com>
 <CA+EHjTzOjwNyUkS5_zSUiAbiCauLKKgkKU6TM_-+Wsh9A0FdRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzOjwNyUkS5_zSUiAbiCauLKKgkKU6TM_-+Wsh9A0FdRQ@mail.gmail.com>

On Tuesday 10 Dec 2024 at 15:14:03 (+0000), Fuad Tabba wrote:
> > +int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> > +{
> > +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > +       u64 ipa = hyp_pfn_to_phys(gfn);
> > +       u64 phys;
> > +       int ret;
> > +
> > +       host_lock_component();
> > +       guest_lock_component(vm);
> > +
> > +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> 
> While I'm bikeshedding some more, does the name
> __check_host_unshare_guest() make sense? Should it be something like
> __check_host_changeperm_guest(), or something along those lines? (feel
> free to ignore this :) )

I understand the comment, but not a huge fan of 'changeperm' as that
sounds like we're only allowing permission changes while we use this
all over the place. Maybe __check_host_is_shared_guest()? Naming is
hard, so happy to take suggestions :-)
