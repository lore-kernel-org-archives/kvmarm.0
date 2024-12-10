Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF45F214232
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733859512; cv=none; b=nGQ352Q1ImOBgbj5V/wFW4lBkizU8S14o0Xt358wzmBpDuoYgfczSITFWBGGaFnPbHkM1O8I00Jc+R7O71ZVZ/ebrf5BrcXR0xiG2P2PEP+SbW8V+zozb+uaXPiD0m23J1D7tSbIiY3onLHCqDfdXNtPRO+G+sUUdCQRFq/ZlcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733859512; c=relaxed/simple;
	bh=AQTvlynankvW5TTQ4wAqJvvDhIl/3/qiybDSirkSEOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN4+YXh9ag2XQrPG3RGo0kMdVYZTIY32b9CpHdLwTvf07RfO98PYxIiC9B35SBZxR/fWVqOlEbJazhaslPYlchqFo38iXHc+OqWbyjd+0VCc7Pcuxy27gLZDHhxyyY622ZEYFj5llrl0HyEhbU+Kgum7dvfvxk77NrPPu9h60lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HTA2D9RN; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HTA2D9RN"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d3d479b1e6so5163895a12.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 11:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733859509; x=1734464309; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6C+R+OmaQSfBiSVs1fcov+OgwEH54XQE839GPqKNBcg=;
        b=HTA2D9RNPyy3+ZDjAQWEUSW3DLcOCSE8Va7wwu1YqK4x/LHHU9T04c61GcMGHp3fo2
         s4nI0ahVHJq1EeCkIcCMgh9nqKlioRLsRMny/AFkF1Lm3RYEn6DCs8AJZVb4JvpatbwX
         IY6yn0A6Ok2kozIT/d7YbhW9V6lYcn6IM/IfJOnuv631wdObPXSmkZqH5cpqhJKppXkz
         zpWIxKJMD0qalz6qbkOQpr1hQEUmAUtORxQSwe2gz3tDnaJPkxNhLtlAEDN5Obzjuw1j
         LDobgJ+iRDjvaw99wwq0CxUgnI/jHozCYasOdg/0THOfwHPQy07cowtyf2NVIp0qyLSs
         AZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733859509; x=1734464309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6C+R+OmaQSfBiSVs1fcov+OgwEH54XQE839GPqKNBcg=;
        b=vvxGL4ALMsslv2sXfUjtUgCAKJ+O55T5/QqPZqiIQHu95HsxgGBmY8UgS3wMbrYGAV
         HdrBcSfbq+6nWIUJQ/8nLCAO4mC02mPPZBsG+iNAFjPr6oXtR2rSdAtxkVR7z+LwqnNo
         aqnoRsAXzM7/fsuln++ifSKdaFj5waudJGomv1ZBcvzIPMuwn/NA3bqducPGvj02P9CU
         mpwvRxW+PRFiu0nnCLiPmKvsxJtWjYRHHlZkmKTQ5+DQ72fk6IiidnrgZ/W4u/xRihc+
         Cg+YJvem0aA2xq0h2Qn08e4mG5LGVyPyG2s8Qj1aDIv4ZWUAZehkb9MNvUPh9Hwps1HY
         KDag==
X-Forwarded-Encrypted: i=1; AJvYcCXo37jkBBHgPrTEgKR1Ejpw2fV6euQ0Wn8pYq7NWdRvZNUIbZ/BOpMMjAwkuCv7kVe0vvH8Idc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBbTlSpjcuTo1625kjYEMRjpZj5938Y+z28+ExCZ/Z8/mOx4tz
	Ag3Eq0P+/JUYOK6hjXNOFSiRcP/epoIjx7Rpz/GXm4SocchQmxhb2z2PQwqQjw==
X-Gm-Gg: ASbGnctZIoi0roLiS8dHBahY8B8IzC3A8CWXDlbe/p4Q1yvbslwoqR0F0/smcpxd+vp
	DlzlB39Kpputo9Fc+xhOVc9vbz87odKoZAtGf/We7uTvXK5ojJPaALROK9TUAN8irPfemRMgmYN
	lOe1l7j+skCwix7+VSJwTszfllCcObrcq0bzGIlNTtvH9K2yCLb8tfKBaYapDt2phrAt4cR42Hy
	Kyt3gs8XCEvYsE97neIVjdyie7z4fz3T393ZEEWopsnZfOxjI8VzoI/pQLQGEh+6SDQzwAXKQb2
	BkZnD6e/ugWO
X-Google-Smtp-Source: AGHT+IEIqsQNTEuyN6pw6/E5dLWj8qHZRilsuJXfDr6drx/4L726HT8V897DbxQWUpXL/uP7eRX+MQ==
X-Received: by 2002:a05:6402:2712:b0:5d0:9054:b119 with SMTP id 4fb4d7f45d1cf-5d43314cfd3mr23651a12.21.1733859508811;
        Tue, 10 Dec 2024 11:38:28 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3c1f99b84sm6775290a12.11.2024.12.10.11.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 11:38:28 -0800 (PST)
Date: Tue, 10 Dec 2024 19:38:25 +0000
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
Subject: Re: [PATCH v2 13/18] KVM: arm64: Introduce
 __pkvm_host_wrprotect_guest()
Message-ID: <Z1iYsVFgs1Cjwp2x@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-14-qperret@google.com>
 <CA+EHjTx-MZHKwkGYPU+yN-CDkNh1kxTXN8FWTeaPfM95OSkjcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx-MZHKwkGYPU+yN-CDkNh1kxTXN8FWTeaPfM95OSkjcQ@mail.gmail.com>

On Tuesday 10 Dec 2024 at 15:06:53 (+0000), Fuad Tabba wrote:
> > +static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> > +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> > +       struct pkvm_hyp_vm *hyp_vm;
> > +       int ret = -EINVAL;
> > +
> > +       if (!is_protected_kvm_enabled())
> > +               goto out;
> > +
> > +       hyp_vm = get_pkvm_hyp_vm(handle);
> > +       if (!hyp_vm)
> > +               goto out;
> > +       if (pkvm_hyp_vm_is_protected(hyp_vm))
> > +               goto put_hyp_vm;
> 
> These checks are (unsurprisingly) the same for all these functions.
> Does it make sense to have a helper do these checks?

Yup, that makes sense and should simplify the error handling on all the
call sites. I'll probably call that get_np_pkvm_hyp_vm() or something
along those lines and shove in pkvm.c in v3.
