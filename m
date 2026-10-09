Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2349B45A
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791551893; cv=none; b=o32ngrYX9NzgLlseU5bjNSdDhx+LsqGK0y5S+mADxNEJDtpochlt/PMZXJW8bKz5YbjNBEs18uX5OpYejMviaDjwcsfcbMcVuvS1PsM0mffjdukFfQgbNqHiYYpHAX8vrSiVSG6U1QWZMuVEXGpqFI4nkJSOc93Ddh8NdssO52Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791551893; c=relaxed/simple;
	bh=jicZ5wGxV9RO9PDm+tdgEAr9Ky5+AY9v5J8/vhc3rKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWCl0L9Idordw1f8QwMkkLD2OCHhnaOh/nDl6kQo8fiwpUr/JHRwK0hGVhT3bFBUhcBrqdgBBTOu/o1qNLV/DrSVzS8emldNUqjQUoxdxT5hZnvQuqJvcsqVsWy7h8hiyQk5eI2Yyy3DzJWS8gkUfsd0nbLyirmNE1bNwMB3wG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sx6bRupQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sx6bRupQ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49ff680331aso68250505e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 06:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791551890; x=1792156690; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VP6lo9UvxywGclViIScVPks4qj7qP1L4wxVmljfUt8Q=;
        b=Sx6bRupQS22fJoXGgUfgtaBNhDCZQYp78ak51STTRYxOcUOKW1X0tS56a/8VPDyQYP
         DLbObnXKNKNIg40z6fIB98+leActyM9MceFtXiVHlqDbU8/sskeuOiUTOTsX2CvafE1r
         ENtLbgi4W1cOohwvwdTdwsIx3SLqBGCJd1/jmtNB3dCxKs6hGOgjjiU0+q5jCtvmtEzv
         pig7AVSMcWho/Owg2scLX2Qbl5glcnUOX8EuUvj8FHbHxK3zPfXDL+nHfMuYq+4hDR43
         6dlUub00yqXryiDs95Hw3RKMd7PKc2VEfZmg+VQZZmlE77rNcC6rCpNNLRjUneQJ7QmS
         z7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791551890; x=1792156690;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VP6lo9UvxywGclViIScVPks4qj7qP1L4wxVmljfUt8Q=;
        b=lRbjwL+eaDB5m5a3+7Aaewi5YOMq1Eff1kpUp77e5exHHqKPsYeYYWHrsvV5ECHQGD
         AtZhNo8mGGEjTw05KQAsnoTT/F6zEVs7NcXodsybTx5qD2uw/sXAVAa1Snph7Ko3sqGJ
         /eISvk5f6jW/4s+CrK+moh/DORX+dJI+BFhFOEyti4ZR3hKS3d37J4l8+SRA7I+7PKxU
         TGanJJCc/SeGHZ/anbxGeMLNRgHOu6N5DQ2S5MvxGvjTQFuMsZ+kDMVnbCjQD1NusU00
         WrBuaKpw/PnppNhLIOo1kcl8pHX7sWlhK40W7ERbD3It6ggYVadJGj6rDtFVvIQkYawY
         RcAA==
X-Forwarded-Encrypted: i=1; AKwUvBwAd/4WBps6sRFEg+rlvJH4Wh3fWIA34JTNF1C5Kk43qbO8zFpvwCkB2evUvGNNzv6BKw9t4zA=@lists.linux.dev
X-Gm-Message-State: AFuF++n1u/zMGj3bJLWjq2DRBSXsl7ZbBNu8AHleP/lu0VnDlwvtt5G2
	dxp7L6CYVDfN+V/BNh/k+Ux1KhTo9Yo8knWAQ5tHfb6OCp/OonfIiC+MrZ19lU/a0A==
X-Gm-Gg: AYBFou20kwNcMhklrdHMxmXTOeCNX6IRyIk75eg8eusyN16nzmxzLYmSdSHx6Zzvg8E
	pfD3Yzh4zgZCvnnlJWPoqnSeY1IWwTR2/d8+jkGYrChjmiX+5WvD7a+fY256pQ2GHw8nx7G3y8y
	Abz4jS6LwNRRy/TNGqIm6gQLHu4+22dsa0cwvWMqiVZyRDggq47VRqBJaoxYEndpSo4vrr/5ZH8
	PaZ8AxJl8P5P6fOKbee0AFVcyOKefmIHZ/Vh3U7LeElNI+ScJLZ+F9XpTEyBd2jCvNOkF+yqxi7
	fHoMCx8VK9+MTwwX2Mqn4tifIHeSOcf4wz3yL7pqtGwUgO2lQ7hr0wBSQiAriDIkvsQgiNdB9ZF
	sLNi6ryCZbjZzK6eK2syTBUQVLWMfa3rAC6KlcGp/sU0QEUlWYIScKdMuyezfBLlqtyjbdllO6b
	kGVT/wohDafNH+rHArfLxIYcIuwZj7IT0raoPGjH+HVmEqDKUY5VYQ8soN9JEm22DNW2+y9CXE/
	/u2YVrNqvtrNFOvUuqCJgH5100Ok4mnYpNiwwCvwbM=
X-Received: by 2002:a05:600d:8051:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-4a18e4475a2mr39489505e9.4.1791551889336;
        Fri, 09 Oct 2026 06:18:09 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18c1e33d2sm79782655e9.0.2026.10.09.06.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:18:06 -0700 (PDT)
Date: Fri, 9 Oct 2026 14:17:53 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v1 2/3] KVM: arm64: Add guest_hvc hyp event
Message-ID: <asjpgZDRmg54UfTm@google.com>
References: <20261009084529.462577-1-vdonnefort@google.com>
 <20261009084529.462577-3-vdonnefort@google.com>
 <CA+EHjTxzBBDpg3B9Lw47tMWMK+VCjpeEQDgYNKvLUnmUYVJVcA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxzBBDpg3B9Lw47tMWMK+VCjpeEQDgYNKvLUnmUYVJVcA@mail.gmail.com>

On Fri, Oct 09, 2026 at 01:06:05PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 09 Oct 2026 09:45:28 +0100, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> 
> > Add a guest_hvc hypervisor trace event to log protected VM HVC call IDs,
> > return values, and whether the call was handled by the hypervisor.
> 
> nit: only the first return value is logged.
> 
> [...]
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> 
> [...]
> > +HYP_EVENT(guest_hvc,
> > +        HE_PROTO(u32 id, u64 val, u8 handled),
> > +        HE_STRUCT(
> > +                he_field(u8, handled)
> > +                he_field(u32, id)
> > +                he_field(u64, val)
> > +        ),
> 
> remote_event_format_show() doesn't align the field offsets, so the
> format file puts id at 3 and val at 7 instead of 4 and 8. hyp_enter's
> vcpu is already off the same way, so should this be a separate fix in
> trace_remote.c, with ALIGN(offset, field->align)?

Ha, absolutely, I'll send something to linux-trace. We don't have this issue in
Android kernel because the struct are __packed there.

> 
> [...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> 
> [...]
> > @@ -1183,5 +1185,8 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> >
> >          if (handled)
> >                  smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> > +
> > +        trace_guest_hvc(fn, val[0], handled);
> > +
> >          return handled;
> 
> When handled is false, val[0] is the SMCCC_RET_INVALID_PARAMETER
> initialiser, which the guest never gets. For example, a MEM_SHARE
> forwarded to the host logs "id=0xc6000003 val=0xfffffffffffffffd
> handled=0". Could this log 0 in that case?

Ack. That shouldn't be too difficult

> 
> Cheers,
> /fuad

-- 
Vincent
