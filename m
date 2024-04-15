Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C156B3FBA7
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713173811; cv=none; b=c5rR/L5QAgzMfFwJIPVUojINmNPWU6P2t1xay4SOTd0ag/tSJOoNABDn+/OFRK/RDPqin6pjX1/kBHIR5uCO47kJ1T9cDrkCm1W+6EPYDtKkD2JDwZD4DIl/ZV/T7341URsttW/AbdsAn3M66F7wO83SRq7alEX8MaxwIZq5g6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713173811; c=relaxed/simple;
	bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egp1lRosXKCxFNe98ZP0Xzcb8E3cl1Wk3lYzwyFLy+ayjuToPPL0eHORwjUhDoIw3ciEcTSBRaH18qXyz9VsRtR+fWYHEXiQeIcHPhNQ0i0qIsiGOCMZWPkPbEDvebjpmNzg9pEfB0tJW4gi8mguTG+juhnezIz3zkMTwlBacTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L9gHXsUg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L9gHXsUg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713173808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
	b=L9gHXsUgUiY/YUql7ZLO8f4k/d1UkVAij95YEbgZNhpcj3LMJ3/BicD2kHljCqZnZjhqMc
	qlQC0vzJzgVEASQeMrPB9sO79qN/nZZoHoaKVmWSN7rj7wLHkMuC3P2WgcDRMn2TSPL++r
	C+p5RKmbyJZSYTHRLulLBure/p3/IgA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650--BdKoM96MLm61vIFi2bywg-1; Mon, 15 Apr 2024 05:36:46 -0400
X-MC-Unique: -BdKoM96MLm61vIFi2bywg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-343d7cd8f46so2321687f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 02:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713173805; x=1713778605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
        b=rZwLNC4p1UT6avZc77qFW6htYfDQFur8blpO181WStGqAYE3dmJJxvmBPUqyQ3QCIQ
         TlwMVOE6o3AMCYN69XgxCynU6D4xCG7HYZqGdm5GfrVqcCRTxYLkhlq9Pq27ifgOdm4U
         Smk2cKQb2ZD+J6eaN6G87SVXodP5R+dcqYlNnuc9UkSeRVKeQjyq0DiwJGScRdWdEjpX
         MSOqur89g2/7JvlkWHppcOM7H1qtISPmvrS2lg5HKxlDeuAVjN0yg89pphNpSCXh90Em
         2HCWrbEt7KZFO8q2yhpTzo97LWIZB+SlIoe6P6fcZQdGbpDb/CiD+cmIRjuaoh1UzFQ7
         0wUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUS+eJOTzfG4MLGMi6rSJegMYmy9wKp3pQmBxuYteGR+uy/qIPyeEo11FwLDJvxvMlsmA+8ovMRnTKPKHCKEMpqAqxTIYhC
X-Gm-Message-State: AOJu0Yxcmrm6mlRKyA4fMahJ8YSnAoiuJrVLPsr3C5cn+x8ksmhVNh/e
	KqaKX1FxdNkYYQX2eV3YdE0uE8EjtF5lT7qGz5niqcmOSgYPW0KAtF/MO400yYy6YP1/wj2op8v
	eNmYGcEJAea75F1cNBZeaLNbsAYHhPHV2s+U4GVyaDn696h8ZjBWkD0Bd5VOc50nGcZa84cSw7G
	IqXYgBsEdz4GZ+dx8yX4fZYwyIVdlq
X-Received: by 2002:adf:fecf:0:b0:343:7116:815e with SMTP id q15-20020adffecf000000b003437116815emr6536022wrs.67.1713173805491;
        Mon, 15 Apr 2024 02:36:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9VyZ4cL1gMt5C3Rm1mGMeCbp0ev+ZnK3ISZDwjaOKhsE/5f1c9W3T/BTch/CNZkcUDNliLoFPQCPyAXOe+kI=
X-Received: by 2002:adf:fecf:0:b0:343:7116:815e with SMTP id
 q15-20020adffecf000000b003437116815emr6536002wrs.67.1713173805166; Mon, 15
 Apr 2024 02:36:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <20240229025759.1187910-9-stevensd@google.com>
 <15865985-4688-4b7e-9f2d-89803adb8f5b@collabora.com> <CAD=HUj72-0hkmsyGXj4+qiGkT5QZqskkPLbmuQPqjHaZofCbJQ@mail.gmail.com>
In-Reply-To: <CAD=HUj72-0hkmsyGXj4+qiGkT5QZqskkPLbmuQPqjHaZofCbJQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 15 Apr 2024 11:36:33 +0200
Message-ID: <CABgObfbvkuCHT0sFFdJbGHBD7k=QbU9c=kA4xYE4j4S2Mu46ZA@mail.gmail.com>
Subject: Re: [PATCH v11 8/8] KVM: x86/mmu: Handle non-refcounted pages
To: David Stevens <stevensd@chromium.org>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>, Sean Christopherson <seanjc@google.com>, 
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 9:29=E2=80=AFAM David Stevens <stevensd@chromium.or=
g> wrote:
> Sean, is there any path towards getting this series merged, or is it
> blocked on cleaning up the issues in KVM code raised by Christoph?

I think after discussing that we can proceed. The series is making
things _more_ consistent in not using refcounts at all for the
secondary page tables, and Sean even had ideas on how to avoid the
difference between 32- and 64-bit versions.

Paolo

