Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339674E11
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 08:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465724; cv=none; b=ApSs1KZ/zdQW0nCA/W83sciY/FODU9IAtLLT/4ULfmXUpJsEkckRpmf24gZ2M55fZ+nxr4pPs+NzKGOuLQYAmR+ygTF0kMEgVh3LI2rXkIeBBE2RirGVf86ZKIFqE6C0ptMYB+INneN1CMXV4jmT/nFavNH7bOEO+eJqoML/Qwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465724; c=relaxed/simple;
	bh=zVIZhSTjsqJudtg+EbWhrppS30PuFaHDjzQv5SZayks=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=rzEQC6nwz7VK6/EFuoW9N9na/oOqM1miSEAQJTKINPQbLdAs7g5y81YZElgTgif80faCBt4r0UyAwAnd4SW8Hc5ig3E0bh1dz30jYcGE3EYC2/hhwNykBYrBERnFjrvRikigYc4kIp2EEALo1By11YZZzFs5jvxUNintKRWbBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AuboRDI3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AuboRDI3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714465721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7jXu5WW2z06tFPZU+cHfWGtYYrYQM0KOVQoh/atcf0g=;
	b=AuboRDI3n95AmFFYpj2cDagkH+pY9uR/RagqAaqDyqGfjk8yxlWsPUeD7dzddoXJSU3zjd
	Mlkf3XCGelYAp+QBxU0ubZqepYS0GkfU7coZOjp7A8lqYlUFRM9gSKEO2I2hsR2RsM6Syr
	VT35xEzoFLAu4Cz6eFYOpdrKoAqcn5M=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-Cybmm6rRM2CQa1Vhx7DneQ-1; Tue, 30 Apr 2024 04:28:39 -0400
X-MC-Unique: Cybmm6rRM2CQa1Vhx7DneQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a526a77445bso359342266b.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 01:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714465718; x=1715070518;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qWhc0CpWpoN7BapWLkydzM5oRjm4NkYTj+vkRyutCqw=;
        b=Z2uWlQkCaZ2XRcyOHZTGtIxlhMo6wy/FsUjQM4dM12puy7xKhqZMtC088h7xYqij+x
         Yu5GTfw4ujX82zg8ZGN/eCpLLY4h3H+ZGq3BMaLKfc7g0P2Rtp2PI+QjJKbtHT8C06od
         KXNjQ5c3MHMZSRRReiFOS/yNvj6c7v/Tur9rL0P0xWduNfM9lhNsAdMHJ3BE+2XbFazM
         RZhn7bww3feca6Tff4ed3RYOYYX36nS7JRwybR6G3j0OEOq96BukaDt4JOX03VyjvEmv
         pM8bCscqVld4oQN28wjzDVRsEZv7EwM+Yb3vaKQjJaag+iJkH1N0fgLeHNArwJfpq9aB
         /1Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWP2w5mGFaLxD1WOelgvUrfQuRLdjwWMwhHH1wMJhJRpaM3c1yucNDWxVyuG2BAPHyRgL3Z1K+BYPdpL/AavZta2L8ELmpW
X-Gm-Message-State: AOJu0YwoRhp1leHOWTba2azThdeywXYpIC7hdcPKC95CCmvn21LZOCIr
	XgkZbXyCpA3fqNIPmAnVDSUCL8iX5iVTdZYzjGzn3FFP3a2js+qlZtEAzsfClqsC1JM4jlUPEos
	zdLE1KX85pn9lcScIKXXxxYQlRxyGlQm5DvhvpX65f1HKzExM5pmlUQ==
X-Received: by 2002:a17:906:c0c9:b0:a58:e10b:6d72 with SMTP id bn9-20020a170906c0c900b00a58e10b6d72mr7297419ejb.75.1714465718044;
        Tue, 30 Apr 2024 01:28:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDZu4JzAKoo43Qd/YU/l0mPuHSFU/feEUQjApeE3UP63GHF3sHOztakznkFanzYyaZuQkDEg==
X-Received: by 2002:a17:906:c0c9:b0:a58:e10b:6d72 with SMTP id bn9-20020a170906c0c900b00a58e10b6d72mr7297398ejb.75.1714465717664;
        Tue, 30 Apr 2024 01:28:37 -0700 (PDT)
Received: from [127.0.0.1] (93-36-28-107.ip58.fastwebnet.it. [93.36.28.107])
        by smtp.gmail.com with ESMTPSA id n21-20020a170906725500b00a58f498ed33sm3062077ejk.134.2024.04.30.01.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 01:28:37 -0700 (PDT)
Date: Tue, 30 Apr 2024 10:28:32 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dmitry Vyukov <dvyukov@google.com>, James Morse <james.morse@arm.com>,
 Alexander Potapenko <glider@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #2
User-Agent: K-9 Mail for Android
In-Reply-To: <ZjCo1Qj4k-mbNXtD@linux.dev>
References: <ZilgAmeusaMd_UeZ@linux.dev> <ZjCo1Qj4k-mbNXtD@linux.dev>
Message-ID: <D49302F0-B184-416D-AB26-49C5F14A1D94@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

I was on vacation, and unfortunately I saw it pretty much the day I left ho=
me. I will get it to Linus this afternoon.

Paolo

Il 30 aprile 2024 10:16:21 CEST, Oliver Upton <oliver.upton@linux.dev> ha s=
critto:
>On Wed, Apr 24, 2024 at 12:39:46PM -0700, Oliver Upton wrote:
>> Hi Paolo,
>>=20
>> Single fix this time around for a rather straightforward NULL
>> dereference in one of the vgic ioctls, along with a reproducer I've
>> added as a testcase in selftests.
>>=20
>> Please pull.
>
>Nudging this, Paolo do you plan to pick this up or shall I make other
>arrangements for getting this in?
>
>> --=20
>> Thanks,
>> Oliver
>>=20
>> The following changes since commit fec50db7033ea478773b159e0e2efb135270e=
3b7:
>>=20
>>   Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)
>>=20
>> are available in the Git repository at:
>>=20
>>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/k=
vmarm-fixes-6.9-2
>>=20
>> for you to fetch changes up to 160933e330f4c5a13931d725a4d952a4b9aefa71:
>>=20
>>   KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF (=
2024-04-24 19:09:36 +0000)
>>=20
>> ----------------------------------------------------------------
>> KVM/arm64 fixes for 6.9, part #2
>>=20
>> - Fix + test for a NULL dereference resulting from unsanitised user
>>   input in the vgic-v2 device attribute accessors
>>=20
>> ----------------------------------------------------------------
>> Oliver Upton (2):
>>       KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr=
()
>>       KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPU=
IF
>>=20
>>  arch/arm64/kvm/vgic/vgic-kvm-device.c           |  8 ++--
>>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 49 ++++++++++++++++++=
+++++++
>>  2 files changed, 53 insertions(+), 4 deletions(-)
>>=20
>

Paolo

