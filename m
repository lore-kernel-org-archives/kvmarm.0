Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A7140DFA4
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777339874; cv=pass; b=edq2E+P9vyKfLaY7xKoKN0TF210OXqXfR9/5S1RVI/NCoyZTbtpRYnKU6LziuLnAXntKNh88hh6+6RjsAmTo2VxNXSwaDKdjItiLboGVX73dL7HiQVBcC0SzTwfOKkkgODSV9H9z/Xq1i+TgteLQV7ntzNbC3wYd7CMw4101dO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777339874; c=relaxed/simple;
	bh=4LjWAlj5OfE6nPz04HGOSDf6N9TOZWCWJub84K9Shb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nLld++xSdQvH5S5TlsjYP/qtpislMNm0AURdXZPHW3c1gMf7VFDAey4vwY8K4mGfslFcdEUP2fSMU+Rh6R6MgDeoB0CL/PihmhrGtJmU7jVlHdc8nnDbiv/tIs8Hk25UzHHS4Vtl5lKr08fz/wLIgV4TzduV7Mes+ilcUtLBy2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=gcP8STKY; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="gcP8STKY"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad617d5b80so65371235ad.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 18:31:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777339872; cv=none;
        d=google.com; s=arc-20240605;
        b=VQlVPYtg7SMUe4pfR02MHkG5X/js6DaCO0B8is4kJDps32pGhhBPzrIsvLLwv7EnBD
         xJ7VK+tAMAxgWGBebwVGmpJvjYyRi3KtPuoU9UyPtQ0COlR56QRKg5+0AePTcAttWK1h
         OZ+HyMOc5R11NzFhOsHC6EnzC7DAyCPTe8RTpz1lrs3NrO1dbeJHWOQ9hbyiilEWk1kp
         qt6FGBV5p5KZ/82E7uR4mlDaK5LGbCUNDKUtCWn9Mz1TvHKbp38fhcTkMyI15T4o5Gp4
         iMz5Wh/+R+DibzE4OI33eikZxFp5tVvUbu72Pc2wlTLhREg6hXbdFNCkv38SKDvqsJNE
         p3mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVDB/J4GDc58D/rJhBbvpxXUYt1f3iejtI1opWBv6+Y=;
        fh=gKNoL0Jnoy7RyjtDX44Tyxu+mlCTPxHtGixIRnZYNgo=;
        b=faRvzdkwJHNGcvdjf0w4nUWLd/VMcP/UzObl1PwAn+e3KPpbXEhg5wwKlhkjaA3+oQ
         idSGLlcSNxeJLgMWzotO4+YFLq45gUxAlRVpF6YBo6Ys4NQ6PyTs3KaO0T5/d/2Ildwr
         EGg866WHr8Q2Wb+Mt+Wb3ysteFWTnOLymc67tE4B6+OSPZ10v/gjrrKhIemzrsKqwOls
         unTXaULL60Ln96TlAnHQ/oDvIPujFehJT44hMnT9e9XJevAbxk/3neyaLG7TKo7rLgp3
         FmYjbziOhMfByoLkI0EdjXS97HiviqQ3M5GwFn9PVrlBIJqnrttOsIlv6rUxNXagqMp2
         m0hA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777339872; x=1777944672; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVDB/J4GDc58D/rJhBbvpxXUYt1f3iejtI1opWBv6+Y=;
        b=gcP8STKYhCSF1+7lvgisxW0P8dfPQE9Y/40RCCO9u1IA0aWSqFFNSr+0EoM2njMyEJ
         Yb13JlRMYuSzBSa1+9e5EDyVc0VwdeCRJLI/LXjUZtV9QaB9hdfArjB/8SsBug3W2uwb
         yyl4VgzNnC2J0JgmbyaagcMDsfvLmusT31cQBPn2CTsgYiBcKdPE5lC/gQnEtSHF0fjc
         bvPynFCNB6uFNMine+qOrp6oiLG+Fk/GMai75474S+6UgKsr0tHBdyhEkvAMm3uHlKzB
         ewYSfdzk6uGyr1f2hDtlldznqE+64JqRUEhCqVelpnNzPhxdKa9bDwgH/A8BUL9sOVJ/
         VYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777339872; x=1777944672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HVDB/J4GDc58D/rJhBbvpxXUYt1f3iejtI1opWBv6+Y=;
        b=cBxSborE56o1q9XvUE83rkXtjbu75U+zVSVQQ/aaYrMXmUgjujgqSKFSf0W/84QcY8
         JbA35OlkEk9fkDDEDqCw+V6CgMVuGLoTjYXllX/I+gyY2scKDxkYgYzRDojv9O7nRozg
         cwrzWdeS/ogG1vEN5FbyNiV8/9qyON51eSWLbp9LalRuvJzsUXlmO17mrMHCIgcz7OD4
         7jiSpCirRC0KvLuUsjnD4thz0hiN9M/wfh831LGrjflsWILtMrbIRLsjBJatvzDy8km6
         BAeVZoIzlpyVzunmD701l4ju6dZdZfOTY/mLD/yoZiu86CMD9h92iUJjWmH3Vb1vXs0p
         oQFQ==
X-Forwarded-Encrypted: i=1; AFNElJ9M1LzkVMT0TcjYX7syRj7wm8FpcPPpAIrN/q9kdTAcoqkbwzHMZvqfYBionYE1kphV9AZ56NE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGyXN6u3Jqoz0ZLp1avvLEZXKl8Q023tHXmsVD8V8r0Z9/2IP5
	JJP2inEpHu+YTsnXVF/TdyqzpIChkVEqi73vV94YHJoIph76DUfzrQWz4lQZtI/HbbuR2NLq/sP
	dgNPWv+Y/m0R50J6goP/0vM34tuDQy5DVzv4LKtEO
X-Gm-Gg: AeBDietIHggdvuEfpTl/bHwVBMz9U9PPoofAeGZJupgSLC3dlVHdwpz2GsJeDKiG4F2
	esXEbzQyQYj7iXYaOw4dntbSpdZ7PrETfEFCzd5zmuEGngs3mUSSfyy34J6uTzVMXVc6p0xROWH
	o/R+a6GD9uXgXi1/BIhQGcOSH6pj6NNFN5BKLfuwX70qtxoGla5v+BfIkVE90kEpNzT7J4m6Rcw
	ioGszZcJMvhZdTFUcLBKS5/jlZX3f2TzbjmqrmnwAfcTLZZm24quJaC4aUxCpZ/sCX0E+vDBMdb
	vHJKTEOzbD/XLXVCHw==
X-Received: by 2002:a17:902:ef52:b0:2b7:88d8:efee with SMTP id
 d9443c01a7336-2b97c479823mr8581955ad.28.1777339871992; Mon, 27 Apr 2026
 18:31:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aeoAlVEwzRUPrlVe@e129823.arm.com> <aeoRxWPyOHGJd+Jh@e129823.arm.com>
 <aeoWO2Cwo04YYu2l@earth.li> <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com> <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
 <CAHC9VhTW3=RJ8L91RWXYYA9tFjfSXGN-DMEEwdiD6big9H57Ew@mail.gmail.com>
 <1f78fc75b2e95239973612a4b6c4cc782960b7ac.camel@linux.ibm.com>
 <CAHC9VhS4JmPmCJrYTdbjxb3TO-uK6cB3Zij-ef=wswGce2BGzg@mail.gmail.com> <1e51c2fd090e5ceb07b1d09e50650c70fd3ccdb1.camel@linux.ibm.com>
In-Reply-To: <1e51c2fd090e5ceb07b1d09e50650c70fd3ccdb1.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 27 Apr 2026 21:31:00 -0400
X-Gm-Features: AVHnY4KFlOUWIpfP4Gb0UYo42YH7fwp4lG0sflhn6Go0itDdLXH-l_OT6jI63ko
Message-ID: <CAHC9VhS_WgwhW_NDO91LoTeSzdieGqbwqnwPq8KpavH1_Lwi7g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, roberto.sassu@huawei.com, 
	Jonathan McDowell <noodles@earth.li>, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 6:49=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
> On Fri, 2026-04-24 at 18:10 -0400, Paul Moore wrote:
> > (I'm assuming you meant initcall and not syscall above, but if you're
> > talking about something else, please let me know.)
> >
> > Saying that you aren't comfortable moving IMA initialization to
> > late-sync is inconsistent with allowing IMA initialization to be
> > deferred to late-sync.  Either it is okay to initialize IMA in
> > late-sync or it isn't.  You must pick one.
>
> Yes, we're discussing late_initcall and late_initcall_sync.
>
> I prefer to look at it as being pragmatic. I'd rather err on the side of =
caution
> and not move the syscall to late_initcall_sync, than move it.

If you were truly erring on the side of caution you wouldn't allow
late-sync initialization without knowing if it was safe or not.
Determine whether IMA initialization is safe at late-sync.  If it is
safe, move the init to late-sync; if not, keep it at late and figure
out another mechanism to sync with the TPM availability.  If needed,
you could probably use the LSM notifier to enable the TPM driver to
signal when it is up and running.

--=20
paul-moore.com
