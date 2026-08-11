Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD917337688
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 17:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786468926; cv=none; b=h8rt7z0WrVvvrbo3BTg3jmHUA/WwoRsjJEaFp1xecP25Za2Dt2bq+3W7bsI/Rjm6w20rpV3lQVt9PIMiloQsv5DcQq8IxCQUTSeCwpwSV3982dAP4bm9dqC7H81QiuR6dyUrajN5yw/ktaMbRn/zjiuyQqm6lGAZMV5JnY7GPoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786468926; c=relaxed/simple;
	bh=vR6sSLhLogjcl/g3uUxcV5IhWW8sS+lAQxhBsrzvn6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRmEjkQ06Pswz9joE70oggh1O0eSym3lgjxGm98k96YPNK5OJRJqygkZGvg2eje6D3u5q0Eby/Qj76f9Co/DzX+jvySb6pXdydxPl7q8OU1Su6XYJ0aYZnb2Fxlh+7z232IUvZ5HhL2ZBvhLR+wlvW8PMdlKoSw/7yUXXEMqNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q0Nma94g; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0Nma94g"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-495509b08ebso1405e9.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 10:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786468923; x=1787073723; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XhKC2uH9JNLWHRqJ28vd49ZvOTGeVzPYd+xhSQmP2ZI=;
        b=q0Nma94gXBuF1+ZhjFBzxbLZEH7CD3wTgjFsBGOXzfNWgr4xRwqSvIonA1PDNfisnT
         ELIVk6gkCtxqb5ro7IM0FPzj/SYIOxEkMyL6i6T0ZYyuRxmIjTACIpp50hvcsXjoKIn5
         MgddOiTIML2BI0xid/h1AV6Q/1FfLqzDSDFsHXFegkReE4paEfV2kHx0Ei3SyLgBILIM
         sjbfBe+1Bnv0/zuyf67+UIcvlM5clrsNbVSlCtols+cvQ8/reagroXrDCiv8KnOXnySR
         8eqX4yc4e/aMv33B3LqOQG0i3gEeq/eQkUq5RtN57LvbF6vmDchDJOAFf/EC9jBBUMRp
         1C2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786468923; x=1787073723;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XhKC2uH9JNLWHRqJ28vd49ZvOTGeVzPYd+xhSQmP2ZI=;
        b=Hrefdqjs2tY6atJwAGFOYJD8bozKa54d+zhPKoGfjoEMHMZhg6NA/R67Pz549Ca36A
         qsXE7BXdrqWLEJDv/1S/F1HHbj7WX5ZRqfHW3DP8TqJddfdoHLsoUvVE77Ol2fLvLTuK
         lrgNQMwjXNP4Sqayxo2lwd+k0ikNZEbV1Ws9+qdkLpNvh6Oo98+kWgDuA1nlzk5qEkor
         /EV9we9xEMgebKo8WUG/G/Nd9AqU9PKYCKfRSArmks/08grjNdFIPstlPb4K1pENxCGt
         UHrZkxLKUlyY1ciBAuJ+BJQMZY4WZUQycLs1X6e0ihv+ePfxXD3ze4zuymGC6P2+RZ3p
         4trw==
X-Forwarded-Encrypted: i=1; AHgh+RqOK5TatI8Ple4+Ni665/679KlwLK59W4l2IR3IrdEBWoH20Cxd06McRmdVDpmYFWyldOBTn80=@lists.linux.dev
X-Gm-Message-State: AOJu0YyF6BV3xSArO4ocLt7vAb8PWyfUz02br5i7dt3HXA1PaOiQMqyT
	uL2fdo6Rw/n6l5Ky7dX7vWuNEL/qx6xyhtTuRBQuo9e+cJv7R4j2GzRoAS4y8bV5yw==
X-Gm-Gg: AR+sD11sULaLTKQG5id3RiEBVfNOWW92wc5VqmsHMn5DMF0N8rt+Ks3YXI6+DcYpSi1
	YenU/Q2COJGN8ztmEmbasqRbtLFpc3lKSpLNVLjIYK8EUiCgcVpW/SjJSRGTZPQE8Kwzy995lT5
	YkrsPT6VKqJTn70XZsmIK8tPFeSyTLCJxpVxm3J5eix9SGtZDoFayxzI7b/nz2zzcSXT2pntfT/
	njg58+J1OaZ8WGHyn5xzixXO7sbAXlAaTmD2VoBb/8frBXOgG10Pj3xJmB66/qa5H4uu6c6MaNR
	yWt42o3RJGd7uu1p917cp216kA/AvVR7CDwONIpAClOQthMSQrPSynySw+Q1UZdGy0KQ3JBmg30
	LO0AN05c/ZQGFWvv5YHuFASkdmillBtPW/KP8f2lcQHWqnE15/1ke+1UYu4RGzqUSnUqCCp9zb7
	oFl8tggLVd4thKjrIgg2OseykCnHV9gb4lhkTJzcig6hpZAyW2oMuD3IypaEcxvwea4ELn2ucV2
	hKpPQM6Fdr2zR7sHv945xsslOk8vQ==
X-Received: by 2002:a05:600c:4e49:b0:495:5515:3c00 with SMTP id 5b1f17b1804b1-4997aeca4f3mr16485e9.9.1786468922574;
        Tue, 11 Aug 2026 10:22:02 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a7097b8sm5888525f8f.21.2026.08.11.10.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:22:01 -0700 (PDT)
Date: Tue, 11 Aug 2026 17:21:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com, sebastianene@google.com,
	keirf@google.com, yaoyuan@linux.alibaba.com
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for timers and pKVM
Message-ID: <antaNocfJp6mX-oV@google.com>
References: <20260808085824.732659-1-smostafa@google.com>
 <178621460524.381735.15023846552532101058.b4-ty@kernel.org>
 <CAFgf54qY8c9wO_RHQZpVSKUCTOgr+WWKCxetjb6BGf-G=5OTSA@mail.gmail.com>
 <86pkzo23u0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86pkzo23u0.wl-maz@kernel.org>

On Tue, Aug 11, 2026 at 02:18:15PM +0100, Marc Zyngier wrote:
> On Tue, 11 Aug 2026 13:17:25 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > On Sat, Aug 8, 2026 at 7:44 PM Oliver Upton <oupton@kernel.org> wrote:
> > >
> > > On Sat, 08 Aug 2026 08:58:21 +0000, Mostafa Saleh wrote:
> > > > What started as a  small patch ended up as a 3 patch series thanks
> > > > to Sashiko.
> > > >
> > > > First patch from Marc to consolidate the offset calculation,
> > > > follow up patches fix issues with non-protected VM and timer
> > > > offset and protected VM running with broken CNTVOFF_EL2.
> > > >
> > > > [...]
> > >
> > > Dropped the unintended SOB in patch 3 you mentioned.
> > >
> > > Applied to next, thanks!
> > >
> > > [1/3] KVM: arm64: Make timer_get_offset() work in all contexts
> > >       https://git.kernel.org/kvmarm/kvmarm/c/2858600ecd01
> > > [2/3] KVM: arm64: Fix timer offsets for non-protected VMs
> > >       https://git.kernel.org/kvmarm/kvmarm/c/47d3eef780e3
> > > [3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
> > >       https://git.kernel.org/kvmarm/kvmarm/c/2e813a6e8ebe
> > >
> > 
> > Thanks Oliver! I believe there is one more bug. I'm not sure where the
> > bug is or if it relates to the broken timers.
> > Before those patches I could not boot a protected VM because of the
> > panic, now after booting protected VMs, I sometimes get a system
> > reset.
> 
> On this quality HW, this is usually an indication that you are taking
> an exception in a tight loop.
> 

I tried to add a poor man exception storm detection in the kernel
handlers (el1h_64_sync_handler and __gic_handle_irq), but it didn’t trigger
before the reset.

My hunch would be that there are some paths in protected VMs that takes
too long that the watchdog fires. I saw the resets mostly at either
userspace boot or VM teardown, otherwise the VM seems functional.

I will collect timestamps from hypervisor entry/exit and check
how large are those.

> > I confirmed that cntvoff_el2 does not get written to non-zero, I also
> > removed the sysreg write completely (rely on xzr value at init) so my
> > guess is that the HW might be allergic to more than just non-zero
> > values in cntvoff_el2.
> 
> Is that in hVHE mode? Can you trap the access and route it to the
> existing handling code?
> 

Yes, only hVHE. Protected nVHE works fine.

One interesting observation is that when starting a VM with a single
vcpu I don’t see the reset anymore compared to 4 cpus before.

Enabling traps for timer unconditionally for protected VMs still has
the same issue.

> > I do not have issues with non-protected VMs anymore.
> 
> Do these run with an offset or not?

Yes, they have the offset set from kvm_timer_vcpu_init() with
kvm_phys_timer_read().

Thanks,
Mostafa

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
