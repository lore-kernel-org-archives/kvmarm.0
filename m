Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F80C4D9F2
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854664; cv=none; b=O+qYA2/oKN8y+XboWYnjh0HtQqbeuD6xEzmfHE+GgkB1xdlLGNnw2sl1UzMifK4LyO+sJEklSHMPhKdNquFXWAw4tR8LArC3dWbIxPBPU3aWqnL9MkUUAj8AfGaq+JW6tWdN7bOX0ZbtSNVU0ubV59VY71mGBtvY7wapcVAb9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854664; c=relaxed/simple;
	bh=mW9Wy5zwtCPwddAQPsiCFCBdlF3xxhTlbzOesWPW9Dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EuJFlkSepo6rr5QGssMCGRHmntWaEc0Ji3Ej8CwUAIxnbc1nzTo+xo3a9BwB3WvJjygXMoKaDCsVUAV7YeYBBPi5FErrephdckOa2tchJ9OrVKh0DMeQR8Fu80ra/ZxMx8czL1CT94i70Lvneb2REcj2t+Vld3XJySYxAG4J1L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QSf0d64F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QSf0d64F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712854662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzMoeKDG3HLVO21BydyhZtfJookrt2+0z0ZoaUJK4l8=;
	b=QSf0d64Fwo686YFOfs59mCSQP1948Un0RA/fQ3Yiu9BZfzEx1iO4abhyTd98Cu2cYnHx5M
	altpxNCL/do7yMPLufPTpDs6+a19E5FUoHcy5LHTkDVMesac9On1XS8or3LU9V2mFiF/t6
	RCkMkz83fe59JTi1rwNLhnnXZrVqR0Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-cJ9WUwyiNRSiSWJjsXlliQ-1; Thu, 11 Apr 2024 12:57:39 -0400
X-MC-Unique: cJ9WUwyiNRSiSWJjsXlliQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-416bf29ef94so379035e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 09:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712854658; x=1713459458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzMoeKDG3HLVO21BydyhZtfJookrt2+0z0ZoaUJK4l8=;
        b=SA4ia6aUeQKQ00e693EtFyKC6K6N7nJffeKNxE/O64Rb/uBdPfw9ZDiLfrnUiD2KdG
         0UGnNOS08lnqL+PEV3ktFxrWxwbgid9IABnQSpS90SNeV7POOosQVR3ZSiJ0AdKTej2A
         c96jvZ+y5lV9QDymX/JeFQuqpkwoKik6u599GJflklIcg8Gy7pKbKNVCLvTw5KECydXr
         Zih+A44XPH/6vC46MFsYcmhq5ca0QR6F3qHe73wojZeSKUloWbZoxBsPK8+vQIcCBh1K
         NwedcA4F6dew3svLY980VdICi8/cjuwq/xbCNHgBAAm6/PDgGemQVuEpCdcvpWhxSECs
         QBXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGBTvCpzAQlASyJt3yUDRkdsNOMlDGFDSjeSZC3lVfyk83rVT0KajyWVkC+3au5s7LPbOVGmD5UKAcpiwF45quAMuRgLpm
X-Gm-Message-State: AOJu0Yw8nKv1MHCKOxNM3VvCwzRwO+XFYfjeJfYCxawfp55+dPz9cP+v
	7uXux2/Fk4dDRtz0iKhQZKoFqep4CnhCCCOALksnK4NmBsU0w29VVq8EIyL8RpMilvRsDFCG+8y
	2PNM5pQcA9JheXP7NZ9QF5pRgXr6EVqhVc4y79TAnTG4RBHcJbWQvonRVUCq4rSD+52TwK+sSPO
	k0Lj8/wlHvk6/whqjN6cjCamgFNBSt
X-Received: by 2002:a05:600c:c07:b0:416:b75e:ffb9 with SMTP id fm7-20020a05600c0c0700b00416b75effb9mr294499wmb.19.1712854657985;
        Thu, 11 Apr 2024 09:57:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmoGFz39xTCvG23vKtpQgogb148s+KvVt7/U1rBvktp1dcwHHxjM7spsq3rgOmQW5LGi5xUnT62q1v5vcy7Gk=
X-Received: by 2002:a05:600c:c07:b0:416:b75e:ffb9 with SMTP id
 fm7-20020a05600c0c0700b00416b75effb9mr294473wmb.19.1712854657685; Thu, 11 Apr
 2024 09:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405115815.3226315-1-pbonzini@redhat.com> <20240410143020.420cafd47bf8af257b2e647a@linux-foundation.org>
In-Reply-To: <20240410143020.420cafd47bf8af257b2e647a@linux-foundation.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 18:57:25 +0200
Message-ID: <CABgObfZiEiLbbp35gNmSGd9vNr03__Eep+D_Mj7r2o+XbF96TQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM, mm: remove the .change_pte() MMU notifier and set_pte_at_notify()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 11:30=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  5 Apr 2024 07:58:11 -0400 Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
> > Please review!  Also feel free to take the KVM patches through the mm
> > tree, as I don't expect any conflicts.
>
> It's mainly a KVM thing and the MM changes are small and simple.
> I'd say that the KVM tree would be a better home?

Sure! I'll queue them on my side then.

Paolo

