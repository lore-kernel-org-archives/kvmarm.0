Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506730;
	b=cbZPU1yipPNDNm0XJn5fZyyMgyHmeht2zdXOUzPEq76zy/C2gIGV5xiLvH3LThaSG6KL
	 3qvEfzemzHvsO1IuVucQ5H76lYlHKvniGhqObNqaJ3Dw+SD5PpGKS65V+KfTao/0Avkv2
	 U+DaSZoNv13lqxnyxhV+VD9SurmAp6flhSmukamySuIV7SjwKz8EmLkT5VT2WoYsUsgHk
	 atnOp9gmYvSSCcwBJ80Snr4ELQNgMFj/YwUQcZVpIHEbNKOogN8uhC7HvmOK7lXfAzbBH
	 B3BknJ9GUHjzz0XyUUSYJEgmS1FcfeMebAeNhqyc13YL0W6vVtghZFW515Ourb+6evg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506730;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=9m/11DSxcPgbs5lZLc03ZXewZlnMeb5irGKT1kB6Ej0=;
	b=m+gBMqPBOTwAUZyXnWkCglxwJl+MwjC8e4PNYd0M9cwgj55JqlWbeaEnfeiRTEAnTScM
	 AblPaLHr4zUFEPBmGEwQYPrFmNIIx432lOUk7uTc/6TR4KrT4bJ+p6sYhQ4GM89XOgpLD
	 B77PZvBZJOuLHs/fqHsE9LPrR20DxFoA/0VfO9taTI4AM5hfGS/0ISkLsOOWI4HLwTPVa
	 donqEsxU3qIB49gfZqbzJEvGeWgCA+2nsmSB60SaXRAbXvMjiZ6l+A5lRGPRwvHEwksZx
	 57NcavsHuf8ZtGiIXTKYPpAG6fLjaTmFSoZdIG2U4MQaHiK7w15wl0zzsjVPEsdDdgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MCWF2CN5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CEE606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42CEE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MCWF2CN5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792506729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9m/11DSxcPgbs5lZLc03ZXewZlnMeb5irGKT1kB6Ej0=;
	b=MCWF2CN5owEWYdF+kOLDQ1d/o95X63GBmm7zkSyabjtn/sCKZqe9KqRQtMQjwNDOcjGIbx
	hjFmvPO2XMrINMH+T859b12gE3ZlInXuBzMBs/wj25CoR7ECOLwGyj5FdrJNP7QUF4DZL8
	rjB59Xhy0AaRPlm8iFyPfvWrM/kAwm8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-6q1-no4yMtiOuvB9JKsf2g-1; Tue, 20 Oct 2026 14:32:07 +0000
X-MC-Unique: 6q1-no4yMtiOuvB9JKsf2g-1
X-Mimecast-MFC-AGG-ID: 6q1-no4yMtiOuvB9JKsf2g_1792506726
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1bfd5516bso33662335e9.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792506726; x=1793111526;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9m/11DSxcPgbs5lZLc03ZXewZlnMeb5irGKT1kB6Ej0=;
        b=yuZJKQtY/x3+FEVstHDUedxzDV5XvoABkmw0IUplrgVnSZ/N0i6e6mFkIpH6MGp00R
         23NVVDlVSppvvlcoVKeAEpg3dTBz/eLTwx2RZJ+sWlIhELXEFVlsbOY+btl/Y6TswgzT
         prtL0unoZBqUk4GL8FlYYbl3BnOUARzZjHZKXILh8ZHKmlmD3qRM6W54489frkdQ1Kox
         DSbRRrlsv38wnKaDUfiufpyFxKhsUHd/u4oAjGXTPaX+aOlQDC/QIYS8zPV3qDzS+Wml
         w1vImzteHeX/N+oUpgixxPni8hGrP0XXhx/bsS8+sVi2sCLZfHYvuu0VRYzWUmiXP12y
         yAbw==
X-Forwarded-Encrypted: i=1; AKwUvBzGQslFJdQqgsBDllM0ZcMNNWPP+KPgGPARzTBg3jO5k4tZiZIEEy5FmP4r63+6hrLGtus3uGo=@lists.linux.dev
X-Gm-Message-State: AFq9FYItbcSMQ4bECFdn5HA6tC2NtRDpwk0Uga2TSJi9zhPav0f7JXnF
	+6eVnEWfjNm01L1PH6NBCHeot7L0HNsI1Nk2ZGvDoQujInl6OQzj0s4JjL5FLOXLOi+WesZqRLB
	qHs4E9ygThVB3Bo6FPYG0CQ/hR5k2G2hiGNbr4IOXVjk3mvv6GrANucY2vA==
X-Gm-Gg: AYBFou3V8AKx0S/rK5VBVVcPJlRW3qZa5b99cPRUzlibd7nORmFikwmTbDXd6WyAk5g
	2alHYuWRTB3RtXPXmaf1REQwQRiBSXViBlzar/SW2o+vi2Zcxiiea6YADUto1eqXQscIuWmmt3U
	9mALcGAR8ZRO3U3Bu1Nkbn/QJzdTok+lLAZOYZrqEikHSQxVH9VneIPcLCkWPK1P6AIJIjz9Fnc
	NAUxtYWJJB4AJshTGeFrOky5LULkEDF3m5Xpo2D0456YalwijzoSZlWhUHAbjqfhJRYGPy4Xc7b
	yvr5E+N5AUIhkaGBRJR7t81xADfifD0HOFlj+SEWxzhAmVrSa0mPT/ynVBDI
X-Received: by 2002:a05:600c:e54a:10b0:4a1:a475:d885 with SMTP id 5b1f17b1804b1-4a1d7634d26mr152603035e9.34.1792506726269;
        Tue, 20 Oct 2026 07:32:06 -0700 (PDT)
X-Received: by 2002:a05:600c:e54a:10b0:4a1:a475:d885 with SMTP id 5b1f17b1804b1-4a1d7634d26mr152602655e9.34.1792506725889;
        Tue, 20 Oct 2026 07:32:05 -0700 (PDT)
Received: from x1 ([151.41.153.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d85a9bsm85090445e9.15.2026.10.20.07.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:32:05 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:32:02 +0200
From: Gustavo Romero <gromero@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sascha Bischoff <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, oupton@kernel.org, eric.auger@redhat.com, seott@redhat.com
Subject: Re: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap
 registers from FEAT_FGT
Message-ID: <yimzz3woyb36x3rmo7kzdggikxv742uvv7ykg47fx4trb6ar4r@2d4lhe2sha22>
References: <20261020104138.2641586-1-gromero@redhat.com>
 <36a94626-f760-4eb6-acf2-13c1ad128391@arm.com>
 <k5dfmpduel5iejhmmk4htypmuxsoxawwsuetyivm3r6adkx2d7@wn52vb7qzmos>
 <86tsmgzcds.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <86tsmgzcds.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HyhMsvDE4azgywtGv-JkXW5RzZLStFKnCsU0OLK7iqQ_1792506726
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 20, 2026 at 03:15:43PM +0100, Marc Zyngier wrote:
> On Tue, 20 Oct 2026 15:03:24 +0100,
> Gustavo Romero <gromero@redhat.com> wrote:
> > 
> > BTW, the output in the thread you pointed out:
> > 
> > 	(FEAT_GCIE ==> v9Ap3)
> > 	(FEAT_FGT ==> v8Ap5)
> > 	(v9Ap3 ==> (v9Ap2 && v8Ap8))
> > 
> > seems some form of processed AARCHMRS. Are you folks using any script to digest
> > it?
> 
> See the tooling branch in [1]. You can point the scripts at any of the
> commits to pick the version of the JSON you want.

Thanks, Marc!


Cheers,
Gustavo

> 	M.
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/maz/AARCHMRS
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

