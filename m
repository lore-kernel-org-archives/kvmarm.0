Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E624A1DFA
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 11:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471213; cv=none; b=p9mot6SF0ibeM5JmYaO4cHMA8ELQNB5C4fEZro6EMjVQN/+JkxcrJGAPzGDiUXdeX6cnqcrAxKJ+47MfZcag6c1KyTscCVC7GboIdULFyE6+hRPNSUNxSdWLcXU4aTiDHNbRMaatxFHm8oqQZXZhtUJ3Y3XZ+gfiTHqYmyzbyG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471213; c=relaxed/simple;
	bh=JtD89L1dx4UJ/DydTrhuEnA2LjRpfNnvhSqmPT7Ris0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g3OvQGb/CdXBFb+KnyKvgswYypda5V0JbXSMK4kzw3L+E03OT1dBk8BgI+8GGoOzCNXuT7hQqHNo0GxlVP2pcsDyDpNkl3wT0ucXK962ayTrThWj+I5pZBjLq2f9pjJI2GvmeBMRMtuB3X9tPNLLn46IT8gVru3PTA5wIGAjS00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CUHir7FD; arc=none smtp.client-ip=91.218.175.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CUHir7FD"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=JtD89L1dx4UJ/DydTrhuEnA2LjRpfNnvhSqmPT7Ris0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789471207; v=1; x=1790076007;
 b=CUHir7FDnLUCqsGfdzpCEXhy4uEP0iDXnULfCBE8BQPZuuDM6Ghr7BFefxD+wDJTwQaxx8fQ
 0lPgQywBwUCBfoyGg0IuVoJQQO/i5nSgxFIZ+/uaMoBufq4IjOZ/Mkif0ZVLI4EqQ7DbpdkRl0o
 hqDVuF5JnkrLKtEjWPpl8NkQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 35156abbd6bd456d;
	Tue, 15 Sep 2026 11:20:07 +0000
X-Mizu-Trace-ID: 35156abbd6bd456d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so4655e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 04:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwdL1maSvHZRFZ6NiwaevQogLb9kyQHEVXCLgUHHv3OZeVDxtKVOYDHWzGcwt2ZwSlu9OAfut8=@lists.linux.dev
X-Gm-Message-State: AFuF++mMdkeHhMFYzROTa9qgbM0thJ8hn1VFY72Uv3lNqQbSaJrmNZt8
	zoqSQISBPEO7spK2TUroqPfONddTbPQH0gJ7pZVICi6eIbvC69usygLKs4gFoXROMr3I6MuCXEA
	qBWOCxkTdY1nMOdcq04nGJwNdnwRAa5SGPVGt57NY
X-Received: by 2002:a05:6512:3f01:b0:5b4:9dba:4ecd with SMTP id
 2adb3069b0e04-5b8b320b1e7mr115483e87.11.1789471202368; Tue, 15 Sep 2026
 04:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-13-fuad.tabba@linux.dev>
 <8633vc6jag.wl-maz@kernel.org> <CA+EHjTy6F9tG=eRLMuykc12P-Oc2pjMoQqAz34iGR+Q5GzV2jQ@mail.gmail.com>
 <86y0d26ale.wl-maz@kernel.org>
In-Reply-To: <86y0d26ale.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 12:19:26 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzJzL420JOcFCnnPQAM1oFJ0dTKHxjBDr45CZasAxzhHw@mail.gmail.com>
X-Gm-Features: AcwNN1W6ZAFjFHfA3IpEcZtftsyHh3ZzGb-8lmwznnDmxio05774SB6E7nfAk7E
Message-ID: <CA+EHjTzJzL420JOcFCnnPQAM1oFJ0dTKHxjBDr45CZasAxzhHw@mail.gmail.com>
Subject: Re: [PATCH v3 12/18] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Sept 2026 at 12:02, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 14 Sep 2026 15:43:16 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > > > +   hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > > > +   if (!hyp_vcpu || hyp_vcpu->host_vcpu != vcpu)
> > >
> > > Under which circumstances do we get hyp_vcpu->host_vcpu != vcpu?
> >
> > When EL2 calls __kvm_adjust_pc() on the hyp vCPU itself:
> > __kvm_vcpu_run() at guest entry and inject_sync64() in nvhe/sys_regs.c
> > both pass &hyp_vcpu->vcpu. There the vCPU passed is the one to adjust,
> > so it's returned as is.
>
> If this is the sole case, why not check for '&hyp_cpu->vcpu == vcpu'
> instead of this odd inequality?

That's the only case. The inequality is the same test as in
__get_host_hyp_vcpus(), but &hyp_vcpu->vcpu == vcpu is clearer here.
I'll change it if there's a v4, or feel free to fold it in if you're
applying v3 as is.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
