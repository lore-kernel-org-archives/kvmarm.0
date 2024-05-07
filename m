Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC916C84A
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715103541; cv=none; b=lDaV3A/Ah3Sb14SCBV5szMFAwjH5oRNlPxkLGURth8bil9NLqbe+eyb9mcj6wytQF2VrG0O/RERAqOsdmTjAkCDZCbr+qlQ6o4Tr10slGUE8MezRsQkfbqAPKwrNjyrggeWrHPLGwunCrzoAasUbFI/MbpZe+yokYViVa+mzqdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715103541; c=relaxed/simple;
	bh=WTjXTy7wqZqLJ2IOdQbN/WBzFAVFvlAg4Ue04sW4qjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+SmNDHFW73IC8jCDsQWCY2gcqicfLyKpWL+jqtAkgL9YtyDkqztZ6pVfE9AnA0in2rPcU881y8bXkY/O7k2MPSk5gptf8OFhFUEeEi57+6D8Yle2IKuwzVId5PUfxZJbJPkEZKg+ykrQUDfZZ0qVypWhiHA7SXcV4wVrJLvCXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TBjMxUdW; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TBjMxUdW"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5b20c4eda82so1327735eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 07 May 2024 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715103539; x=1715708339; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAE0qBIGceUphb1OEYQYrxoiW/szPAeOPJX2oKsvSeo=;
        b=TBjMxUdWQzm3XzfJ0zFVNZ6bl5Mj/3TXmgQq0xacqC6yA40vl02huhBv30ZtIedmIa
         meO2FTfiLQPJw5kL7L0ttx9U6Du6Mzq70hklrUeMk4CzLyimSDqMkdjJ7jPtIs8i35wA
         Gfpy3IeSBL+S7wCzBw3XQdTPRIaWoywT8SBe1HK+ELKhvKEhVlFf4i5OaA6049+oXLiX
         y/foCP5IsFS6H6ZKxV7bgvX9tQYGUirpao9BD1xk7wD/Rq5BOWeT0RhEoSOJwF3WXl43
         hmzCMl+Hvfib7TIAr48DEytZnZEd+2Xc4NAKeHbWvfILeDOy4VTL8lUHcIhYktILGQj+
         Gu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715103539; x=1715708339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fAE0qBIGceUphb1OEYQYrxoiW/szPAeOPJX2oKsvSeo=;
        b=djkH3UiUvv3CPfj41nKBqLQgWW6d7hT7MD6oja9XfRhUk4hc1VaZL4bLroHSiAtX45
         qVRuS2uSWWkXUyRusSy0ovpvmyCWJec49A+Bfimcs47LDsQWq7rVjIjinf7dMDwPxIdg
         NCOHctOdtdcam3qVPVcbNwi4+BArFYuCtKToY/k1vV6Aeqif4DgPwe0S6pvfpE2egShb
         NPI0KFTx8lteUN6H37rh98eQ2N22Dqlr6bZwRIV58X0Ijkdypqgx/HsKxyXvJ1xd4bfk
         K6W3rHbiMLYrrYBVCgQCRpCRQOCM74Bmb5BNgDLrp+wPAgCB18avG78HT1wnsMYGSLTw
         1pPg==
X-Forwarded-Encrypted: i=1; AJvYcCUGg9BMYlPZhgn5WKATKd9/iaUadLZfrYdcyueaNXNXCnS2u72y3y3y82yq9umVGNwjz4kFb8RbI3VJto9qUe/z2+lHTTq8
X-Gm-Message-State: AOJu0YyzjgQyki4MsXULXGGKVyNefZvBYFbqCi+KrbNN3ij4LvKKitM1
	6S1dWCkmyQbXqlS+4XPCIlGNAWxXtENQ9z/w5Pn+5dqYB3O3vDShFXcuv8ObhSNs634xU6u9VHv
	JSS8F19ifGW5Y0t29TTYx1E+PQB9LjwwZuHmh
X-Google-Smtp-Source: AGHT+IGOlj4f7H0eIZnf/AAGA9xhg2BLPoln8xEDIp7mRv/sk45u89q1Eyh+xEgyT8jUF0RWxzhDYUEy7gHdOcN46XA=
X-Received: by 2002:a4a:9893:0:b0:5b2:1095:a58b with SMTP id
 006d021491bc7-5b24d738d30mr139010eaf.8.1715103538716; Tue, 07 May 2024
 10:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <171270376781.1586271.10159724514702496320.b4-ty@google.com>
In-Reply-To: <171270376781.1586271.10159724514702496320.b4-ty@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 7 May 2024 10:38:23 -0700
Message-ID: <CAF7b7mqg5J54CjO6bDsRKvLQ49rk2xcerf8GYATXyd8pHanY9w@mail.gmail.com>
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 5:21=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> I skipped all KVM_CAP_EXIT_ON_MISSING as per our decision to hold off unt=
il we
> see the KVM userfault stuff.  I skipped the docs patch because it would r=
equire
> more massaging than I wanted to do when applying.  And lastly, I skipped =
the
> "Add memslot_flags parameter to memstress_create_vm()" patch because it w=
ould be
> dead code without the exit-on-missing usage.
>
> Please take a look at the selftests commits in particular, as I did a dec=
ent
> amount of massaging when applying.

Thanks for cleaning the commits, and for all the help along the way. I
just got around to checking the selftest commits, and they look good
to me
