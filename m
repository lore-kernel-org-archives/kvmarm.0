Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3004524166B
	for <kvmarm@lists.linux.dev>; Mon, 26 May 2025 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290886; cv=none; b=SmrxGewT3FH4Wy57JfUAwvTWlW3+FGrAArZwJFO8tog+b+37TfkumJPmdUv/DLoCfvA0lQSptOe9vHrVvF9I+Okd2uDmpzqAGAiUtWAn9uhfkaOd+gaRH/UHsGTMcdXMG7pfD9hyB0UcSjzFUdnEdWz9gZLfvTMr58HTj8lZK9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290886; c=relaxed/simple;
	bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aanP2YTkZpoORh0+JJ6buykwXvXqzghxOXGPF7PgDHC4jwYSr34DVVpQAOcGe/REvOKHZ7DAhbDj1rF8s+3Y7k0I/rzmQgxRlsJC1PV3U+MwUNAIOUpanWXqY/BEMpuUPzx33OtzcVI0yBPhAitBe9vy1pq5LVqok7zX64Y8o1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEHdm/O+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEHdm/O+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748290884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
	b=FEHdm/O+qBe9auS6E2hiZuKm3uEJvsWK6q2zvB01uuyNPYPdjmmUilwui+g8MMBhmg9MiE
	ibXThrOWH6wVxeDMXYSBl2lLI39mUu5Nqpt8DwgoRkipXAa43PrQJ7Ohu2PxdzjAoVcOh8
	ImwXYR6nB16ZaHCUu/9v67DyV7oMCJU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-zrpTx3xDOD-gbCwtxudk9A-1; Mon, 26 May 2025 16:21:22 -0400
X-MC-Unique: zrpTx3xDOD-gbCwtxudk9A-1
X-Mimecast-MFC-AGG-ID: zrpTx3xDOD-gbCwtxudk9A_1748290882
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4d95375c6so542284f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 26 May 2025 13:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290882; x=1748895682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
        b=enp87kYDpQGNMlSLx7KU21Fx8JHkEi3O9vTM6lHjGdO68ww5SpcsLmcjmlAC3u0cX8
         S0r8KBONHoszrglQiZ3NUqUHs+S2JUb43Ba8ezS7BhXwFJN47H14CjC21+SVVwE9LdXb
         SJObaWm4XS8Y+BiK2vwhLU0vQdcke8pVoSomDc4aTCqNcfcQFIBugz3w1Ps+AuyFXpuI
         uzWSb3m/orpwBudWr53/ZJdspy6BqKgnCCaNqwF442JvHG7sBAEpqPOTjhOsdWuFUi6z
         X3obpnkzPinmKff8nR17xWHwe6GHpOS3TqlR/yUzgox46NcJTWDNOEzLKZi53i8nzrvs
         aqTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPved3WPcUdkbrljc6sI/WokDToK3jjQiP7Ztc0TnYDI4RTwixlWI134uvMIPbK9awtnBSpBM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXo1xbDzjwd9L/E8GiAnACZzNKTT9Vymvg/3Jh5EtkqMZAI0au
	a7aPIpisLmfM+rZPOyOqbm5L+/RkBUKEghHLWi8V2ow8cLKVo+tPP3q6UCtlewlxVywfntG0A1d
	b6AOehuwuq+lTZDC8FqgjGOIvwAql9Glwe8KmaANvkGkC8lnWvo4EEFb9w21rIijtFSeoRy4I/c
	N4UGhEgJNTYtj19bqdjcYBFTRtnGOomw/g
X-Gm-Gg: ASbGnct1evYRcm2BLGRBBYFzruPBAFe8nDLLg4cVv2gDlDOdyl0AfHvqBEidLR1Rypl
	fTTkOVgrFoYYrN0Xm9v/cLGZBy70OuXkwJvsqGOf3jNVvJJN90BBN8aL9mRR/zNcmQhI=
X-Received: by 2002:a05:6000:188e:b0:3a4:d4e5:498a with SMTP id ffacd0b85a97d-3a4d4e549f4mr4549101f8f.42.1748290881562;
        Mon, 26 May 2025 13:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPfGkLNrDWsuMBcvBhphCxIvU3GI8PzuGzZDpGUJKW1wSG80qF2SscvPTAo9oEnA5hoBADF7+zA/YXDDS9O04=
X-Received: by 2002:a05:6000:188e:b0:3a4:d4e5:498a with SMTP id
 ffacd0b85a97d-3a4d4e549f4mr4549074f8f.42.1748290881218; Mon, 26 May 2025
 13:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250523112015.146300-1-maz@kernel.org>
In-Reply-To: <20250523112015.146300-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 26 May 2025 22:21:09 +0200
X-Gm-Features: AX0GCFszvJZwa7StoX7JqXeC8eM3B-BChUPaDxpaOnMqsQR84k4snxyVAo-DiDU
Message-ID: <CABgObfbAD9W8dFzAPhyayBwohNW+9MpBnHfT5A-KVs+7RDQ9ew@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.16
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, D Scott Phillips <scott@os.amperecomputing.com>, 
	Fuad Tabba <tabba@google.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Gavin Shan <gshan@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mostafa Saleh <smostafa@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, 
	Seongsu Park <sgsu.park@samsung.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fg9G54OPUSS_AgMF6vSwXl5wAtK-M3FWtTwf8qdYxhc_1748290882
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 1:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the initial set of updates for 6.16.
>
> The largest change is actually not a functional one, as it "only"
> reworks the way the guest feature set applies to trap bits and
> register sanitising. This translates into another (generated) set of
> large tables describing the architecture, which is I hope easier to
> deal with than ad-hoc code trying to do the same thing.
>
> On the functional front, pKVM gains THP and UBSAN support as well as
> some page ownership optimisations, we workaround a couple of really
> bad issues on the AmpereOne hardware, and we finally switch on nested
> virtualisation support.
>
> This last bit has been a long time coming, and I would like to express
> my thanks to Christoffer, Jintack, Oliver, Eric and everyone else who
> helped me getting this monstrosity across the finishing line. Except
> it's never really finished!
>
> As usual, details in the tag below.

Pulled, thanks!

Paolo

