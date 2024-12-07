Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D8C25632
	for <kvmarm@lists.linux.dev>; Sat,  7 Dec 2024 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733535490; cv=none; b=YAtuXpl9gOTC6179curp9moul0aLHiAMEy5nhh1lriaGt/zJT7Y77UIGR7KT6kkAiVL1e02U62El9u6H5mFudCqIT+kqzZEG3HgWAN1Hoy0zmdTtAOtJRGWNVW0MsK/zG6cw7ywQA7cu6BskyP9XE3ndQHIgfhGW6xbi2Flixbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733535490; c=relaxed/simple;
	bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMUnO5XybdvB87cn7YNpfZnKmz5vErZeqmR81sytz1fWmS77eqNZXm0j0oqBuEcgcXzGAP9Lu74CFOKK3Y60pFYyBsOpSJT/5GFIdcRcwFXsaxuq/n9PBgk/TU0VNsoTd+KFmay/8sAcD3r7pqFs1LoZN1jCoJ9dJ8TC/CmlyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IA5rHMUH; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IA5rHMUH"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7fbd9be84bdso2600736a12.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 17:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733535488; x=1734140288; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
        b=IA5rHMUHRzWaQ3BKqtSoOcCrAz9LOC9KoSVDHUKgsuMp2KLD1+K8CeB223rUvN/NRs
         LRWotpKTNFiixcrVoTtLIin1Uv74AOwa5lR0meCfUeJminfAFHMREv5MK/PzmnVVLDST
         bYuzhLx9nZ+bInay305nEO9M7JFtcKo2UwkFwC+3XBXVdS4MtLedjcCNICSJkNtUnFGn
         f45yyTz8Pm6XtCnfUGIVsOwZ5NDH3dUG9CC3rduS3wJtorBKJ51VL04H0IVltSgXeTrZ
         +eouBTm5siibx7QUOWWFfu1MDuPb7WqDBploH8tURnoBjp4JYCFgtyeWwT66rN87iNsC
         v7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733535488; x=1734140288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
        b=nbnPAtbmRHIag7RpC9TLES+ZlYQ0gHkVby6N8XQpuqUGJN8Nfs7cInMich01HGqYf8
         4OIUfcKVqIQuZbUMK5YYryZwgVAlBR8IoIerEeyJeQ+kIMYBhWSDiMKjl2IET5UUlQ+l
         rY80jX6vOruAU4u73VYHdy5MT/6xFjFi/GnaoyFrMehDEoU4ps/BPaSJ72dtSSyvvdFz
         Gbqu06kWRDjz8zZWwzWodnfVK1aMrksXVoyAOlHun6J/5gKVaHE5r1cXa+Raer4K5lg/
         mkZ1+2CJoBxtRI6sQVL18lv1ZN56l5W49tp2RwdRQJZDG4tXUGOKRPl30IJJlIAkL2ze
         mexg==
X-Forwarded-Encrypted: i=1; AJvYcCVl141x3jJhhCz9v85n30LvFpB8OuBS1QW5Q0AbY87+qpISnAFRCYoDI7F1iOufP4dW0u41IU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYFg+EK3NYYrH5jAynLrW6fXdRZ2DphgHn2RkG18PUrnShuldf
	gHBOjOQe/M0hxkwu/I4wnZl4XNJkCbxFtPYzt4cHBkWRnIh5Wc6z
X-Gm-Gg: ASbGncvCkTuBIWTm7xmhCro45ApxswzsPcXwUT7H0FtSFyFmvzPX6PXcPfR7qvwUeJh
	yPga4++KyAxFE1bY61zSfr2q6V6x4hqThXgOUl0OtWmYj2DS7g3xTiuQjnUeQ8mNG7ZLyPxUloI
	AH+arSs2JdlSjFU2MVVcKQEEIiZFZT8MWCVdRQlmrR0tlX0he0UmFFo1hX6mEXxtytYqrDdGhlw
	1MEvzcb1vl1U+2lJpUcz0P0h0pGcJXCPHRfdiL6+YLoYnZEIg==
X-Google-Smtp-Source: AGHT+IGVziXDCgJ7WWittmXyPHVbsnVEcC4rwZTr2Vz2SiCLVRLP7xZj3DgIfwKgkAxvqmJSueqbZw==
X-Received: by 2002:a17:90b:1fc7:b0:2ee:d96a:5831 with SMTP id 98e67ed59e1d1-2ef6ab104admr8543489a91.30.1733535488087;
        Fri, 06 Dec 2024 17:38:08 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef2701df43sm6227823a91.30.2024.12.06.17.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 17:38:07 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 96C2D4209E76; Sat, 07 Dec 2024 08:38:03 +0700 (WIB)
Date: Sat, 7 Dec 2024 08:38:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 13/13] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
Message-ID: <Z1Om-1D2g3bFW4U2@archie.me>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-14-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="THWs/xiN6GnbQcla"
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-14-jthoughton@google.com>


--THWs/xiN6GnbQcla
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2024 at 07:13:48PM +0000, James Houghton wrote:
> Include the note about memory ordering when clearing bits in
> userfault_bitmap, as it may not be obvious for users.

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--THWs/xiN6GnbQcla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ1Om9wAKCRD2uYlJVVFO
o/pqAQDAcgOLkBs2QwTaz5H8Cms3BiufYbNEbuR2f2WwKNQOTwD/W/ANv/jXoqg7
C+d5nAhBL0GZGybXynXplppXnFrcDQY=
=04BY
-----END PGP SIGNATURE-----

--THWs/xiN6GnbQcla--
