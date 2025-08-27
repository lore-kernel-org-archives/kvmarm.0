Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6C307ACB
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300302; cv=none; b=ct/+7To8VO7kmBnx5VE/rNtsd0VC9G9/S8Yw/qmohX3DiyhTxU1hhuAFNbDDJiFka7+DzYwjA6Hbb0YTxWHOviSMwqeuXs170gac3tdnh2yjK6YqPJ4krc4J8INY7HAQoBVOvE023N5JsP4k88h7RNwayKHCTTSdPxEp+2aYCNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300302; c=relaxed/simple;
	bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uLNEUO/6nGXV3HpXH5pm5/Pmrr7740jJ0V9bSzAny+hus/E88/Y8zYlp2CQrhosM3AvVpLU4+pslsLBKceE1hp2o4sKT1MlPOUKQQ1gTtPydd0qfB2OTtQwZJXrPfJLgjTQW1cwTTZRf2DzkW6fJVCFofF7NL92zm5Zvis64ab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsgBNfjf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsgBNfjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756300299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
	b=KsgBNfjf/C56wKrrAjdzI5LbfhlMU38iWjWx6KYJORwj0yBnRxCOE0jvg8f+rcn27VTf/A
	W/svys0LiBziZxYu7G8/kmoOGvjhUq38x6PF6ha8rCyQpTq9Lr727w95QjhmARW0LXR9oo
	RCTe3og5vBfajyT6VycaACforChRojU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-xN4Z9xGGPzSJdpHb02n3mQ-1; Wed, 27 Aug 2025 09:11:37 -0400
X-MC-Unique: xN4Z9xGGPzSJdpHb02n3mQ-1
X-Mimecast-MFC-AGG-ID: xN4Z9xGGPzSJdpHb02n3mQ_1756300297
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c6abcfd303so491170f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 06:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300296; x=1756905096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YdlTsQZNNrmq7u3Z5M5rk595Ss//u8ZKePXJNnxhb1o=;
        b=nPmcB0yaS7mW6Fm/Rr0U/US9XiQZMOOs/06NFUKADwBmSReXC9k8hProCF/WWF/yYP
         zQ6bcfx2zylVvb1pA1qiy8pbNklBXaO3AQf+i0Uw9HtnYWtKhuzPhJlrXa0GkDbf0IHC
         16vBeN4QbWb2XqKOblNDzLXRK4wesBRHX3tnOAB5lMyCRa2jrigyJr5WXt+Og2Ujoxpp
         BKIHgX+9Ne2i5+B3BmuuKW08Y+6T71MSDF7p9wGP/9citqKY3AvUorg5NUS2VJiXaaHr
         CEcGUioRLBtgbWt8zHzOq6HKbLxFyLibts4O46RfQWzNmdlEtIXOL0erPhkC5w8ipv8z
         w7Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWzq4PvTM4UCDpBjv30SsffsKorBX6dwvjrFK+/r0zuhs37rE3p35M02k9w8vyCwK+g2gRAC4A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOWHjZgTZ0s3SgtaSahIQhwGWE8/ANemLlUkvQ8CVYVKVlVidR
	MJ+PxUOHdaItbUXhlsMSdT7NW7F/24XGNJ0u4/CcUNJG3OcCFO2NrM8eAta8H+lKoXE7xVnH3kr
	ucMY2tPU7hS/HQIxtdR+5e2iIeo4GAUI7s2yoaWK2oE32wZbLNRYusw5YCY4IBCVuEdyLaUX7HK
	62/v7Tfz0TD8a0/bpCYEDpbr6m8dOzv/rF
X-Gm-Gg: ASbGncvGWTM8GAPbALvaK9N7ejzxpEVdn8hItBjNaU8iX6qKnO+k4Dyg0okxXNU904Y
	Hiu0DcGfzdpqdsn5qx0ZUK6sWm9ow9TZIpD2tKdCquY4ZNoPd95jzUQIdG1Mwux/0tS26SK51sa
	D/mKU+ak+8ZzLrmL1xDbWiMV/Vy+Q8EcGiXKlAMDtjy0PSEbFNz9irPEvBClR77AvsKM2QpjFlm
	2n4ca9X5jUeaitxgYV/sF7M
X-Received: by 2002:a05:6000:144f:b0:3c8:6b76:2ee9 with SMTP id ffacd0b85a97d-3c86b7633cbmr9046538f8f.19.1756300296495;
        Wed, 27 Aug 2025 06:11:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIu95W78Kd2FcqoAMBmRWc50Pfjv6n3rRZIWnWs3jErMyKSztWJGNEOWQHM3H1SLdXfBJS+ZjUc6qHuPBUxAQ=
X-Received: by 2002:a05:6000:144f:b0:3c8:6b76:2ee9 with SMTP id
 ffacd0b85a97d-3c86b7633cbmr9046516f8f.19.1756300295999; Wed, 27 Aug 2025
 06:11:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
 <86frdcewue.wl-maz@kernel.org>
In-Reply-To: <86frdcewue.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Aug 2025 15:11:22 +0200
X-Gm-Features: Ac12FXyek3cfAXJUDvWryX-P1WU7M6mjVSZlZC6o5IXedOpceLYmHnNxWJaWG74
Message-ID: <CABgObfb21UEZf4aQVv_-v3uFCp08G3SWhoTbpmSFz7qL0Xm63w@mail.gmail.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ok_BQOLI09W76b4HX5426nJqjfjDvSzqFb4UJFcMjc4_1756300297
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yo can

On Wed, Aug 27, 2025 at 3:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 27 Aug 2025 09:43:54 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Applied to kvm/next, thanks!
>
> Can you please create a stable branch for these patches? It is quite
> likely that whatever I queue for 6.18 will conflict with that, and I'd
> like to be able to resolve the conflicts myself.

You can just base kvm-arm/next on kvm/next, but if you prefer I pushed
guest-memfd-mmap at https://git.kernel.org/pub/scm/virt/kvm/kvm.git/.

Paolo

