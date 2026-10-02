Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5604E1C9A
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790955060; cv=pass; b=CrimiGt9GcpzoNmOF0WF8o1VpsTA+Zuohw3Bm+IPrWRljA3rSsBVds/2J2QRSLMryvK+QixoD9IJN0giah4c6kr0GgJXxCmvHum914stQ3+YgGubsSfTA7e3/qDuX0tzPPqln9pSPFxSI9IqMf53JTbPP13j/1ClJvyE9nEnwnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790955060; c=relaxed/simple;
	bh=fs5RDQ985eGOdUMkYTIO1AkzMa4f/KMg1mJ+9inMXJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdkEbDrlTsICmNaxLzBMUzEARJ19kcQ+E2GmUmp84f8k0vPh+LC5Sr7HkHUvSfjiqi3uWr3/dEEXPBtquEsF/98RWqD3flioH1Yquqm5Vf8q/FADNL+u4Ni6jGc0anq5SCNQtVnbouNJpNUOVvB4jzW+K2SYtBtm0Pjh62xyXmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kvzh/2XL; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kvzh/2XL"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so7287e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 08:30:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790955056; cv=none;
        d=google.com; s=arc-20260327;
        b=RsSNgrO7UapC1Uvmkn2e4YxmVjWV0nMsYLlj3FWU8imSw61z4BU3HtAXjjj36dyuaA
         40ROpmgs9K8g5N4RMpQoursVE1pZ7hik85RukqrYTf2sl/O8f+FjehqD8c0eP/sMI8Yc
         xLjrcMGbttzw1vcQp2SKfb2HOuw5V7vtz2dXqk73UDntn/Y1fgzlvIaVxxyoE3KXGU31
         IShzQdmApyZY4MHoLL4HiglLZTTldgYR1K1ZUY/OwcxoAtrevBt1seyrWcxfIZHng64F
         mDyu2DB9EgFsaHKDRtApSM1PvmFWymFNzSSOIXyUrABd48+2iTIMu73pFTxVLCOq2y0X
         qIuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TyT67JBWmU8a3Diw010Aiq6t7ByqroB1mQnZlP3DzI4=;
        fh=MaC6lFdo7Ok+xplEUS6aWRUXk4sDf37zGj7NnK90IL0=;
        b=BjMXfXZljRwqvMSa3DCpRuqwcRvZhW5ipHJCCgwdmbsoGG13ihTU1fNGs9EOP1XVFz
         qNncUe1xz5Xs+w57ebl2cMgD8hPF6bNzdFIhaK0pYyJwx6t+9PGRfd0IIwg+AJdF/5qR
         ZB+z9pXvHTtyC0hELG8koTPf+qPhVFQnL0NrDG0F8ohVDPV74az7SqGcdrdfXsol4++k
         88xrAOGZQ3y6CGIE9ibX0wIuN+a/rVpRUF673S7sCrLAVxL6uMODrl22JWwt8h1S6NDP
         FNdQbzu4bCGC47zF9YZd+mix4jH1Z3BSSlLKTyLVnhwskCf5JpZX0hfdwb4vn/2GHxGt
         OHjg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790955056; x=1791559856; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TyT67JBWmU8a3Diw010Aiq6t7ByqroB1mQnZlP3DzI4=;
        b=Kvzh/2XLsmDeY4W9dOk+N1lWPju45l1hE8ZfbBOmFCLDX+oSe1aI5+bMLYjAmSMEp+
         5m2Sb0QBuehmLKToleeKX2hExWMK48gdg6/EmLfLQHjpWCw1ev7B5C7p0//0VTLcaAit
         ySaVHepS5sUW4kh4+GiPC1uHnk+8rCuOilX5MUqEsvzZLxPe/sndHFfcCaIu7z57UXZM
         hTzuE/uC9h656Z0qCKgG1YegxGquXEJajbamwx6UhBvH/pjwCFnL2mLut01O7IoRVET9
         Yir0zNQk0bPWCDIIY9iF3zUysxEp228QkxKpCL9viUY7To277tdnSlSzJh2OZC5sqsk+
         TQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790955056; x=1791559856;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TyT67JBWmU8a3Diw010Aiq6t7ByqroB1mQnZlP3DzI4=;
        b=NUJxz/r7vsCLck0wzvTMdwKTtcd6qggHaasc5dlWsIpVSpiOpQjVXLT1Bmr47t5AKT
         Xgdf2FHMIe3J2Wcsjmf0nMM2K11XbAS1y/1OR/Um0sCAhHdocTgwUbKUy6rRoMYg+cTp
         KeCVgXCXPizGTP4/8JZJs3Z3McdpbluIB0WPcxiRa+2iFkf+NSSZzBiwjw2JJ5WcPuyK
         i6X2XORoDH00ViWwTvVt9DR90Tv19iH71bXODp3UqUy92ZW78AxeuIm/qN8dn+BAyNU6
         YzmEicLao9pm5bVH3nTe331UPlz7qMFXbw130x/fuKDcPNVpS0C8XtwiDgpw0p7W4V2y
         Y+0A==
X-Forwarded-Encrypted: i=1; AKwUvBz3MlLf0gvnPg22y+B859n1nZBZi+FtQP2CYdF1Xyt0auMEa2djPGpQSEdTJtWLWvFyOXKMAcw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKumqUlNZi9liQ+dH/xzJkUTRhOFBfeldyP1iVKmpGBrjRZWSAo
	RTwm2o9PTNQV+xEjeBbN7rx1ctJvoFW1Te0OQC9ocgYMWPFJTfC0rYIaGpgZQNxsyboO69xlaR0
	tRlriFHz9wzYlwdZ56HIaOlPXP1pLQP7LG7iIKWqW
X-Gm-Gg: AYBFou2LXKgJP/sEJWDt88RhByD+c/1WDoO4gLYzOa2cV+MI5QBlRqnhlXska/8HLyq
	8I2daMAjmscP0y0PYxCETK7tOkL26b1Vp5kwCwGKBDCzewuGM+8rVflilNPITWPOD3kw9fzc5/4
	wuy1K6Hr3oXHlN+bVRXTG5jtCMi6fPZy6PGPVMsl4igPpVtM6KfAmMPvrfIuCEQl2qUzx/SMzBS
	L8BcFVCMKYYOnypkKgG40GZJSX4ivdmQvkqAJ2NDs38pK33/IU7yr3F/sy/x2dgoVYmiliDSAYn
	wFP6vovl4RbjWWWKn7M4LmrEsBushrewGRrvurROLsv6vU4g3X8uTXUO/qpV74Z2VqruSmVK9v7
	S7yqVji3+jXru2VTA7naUPIkf
X-Received: by 2002:a05:6512:3b26:b0:5b8:d04b:a1be with SMTP id
 2adb3069b0e04-5bb7c91a8a0mr183008e87.2.1790955055657; Fri, 02 Oct 2026
 08:30:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com> <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org> <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org> <CA+EHjTy4rb+6z0bqh7sPqACES0EDpURdeoyiFGmdw3p0PENcOQ@mail.gmail.com>
 <86o6dc2ka1.wl-maz@kernel.org>
In-Reply-To: <86o6dc2ka1.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 16:30:19 +0100
X-Gm-Features: AclHuK-WxuFGXDBt-i8aW4clYrHg0y_cefCod2ajVZ-nmk2Rl2Vmyq6bDATGZwQ
Message-ID: <CA+EHjTy9wTbjFpgvDOX9Xexw4jpx4uHMHM9ckXYZw8H0_QbAvQ@mail.gmail.com>
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 at 16:29, Marc Zyngier <maz@kernel.org> wrote:
...
> > I know this is a sketch, but just in case: that's inverted. The sync
> > only applies to non-protected pKVM VMs (EL2 ignores it for protected
> > ones), so it would be != VM_PKVM.
>
> See what I meant about this stuff being completely intractable? I
> still have no idea what it means! ;-)

Yeah... what is a `!= VM_PKVM` ?!

:D
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
