Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADCB823D7
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708702332; cv=none; b=DI3cILWHyemD0WkfoWhyD+emGZD2cX6lZpYt+0aLHWRv4RhQg6XD/9qLkKCZTFJtWHwONSRKvTcABG8X7+qnoZio3nQEig1lfya13OolU6J4Nur0NYgfhxA1KRkca7Z15ivq07WtsDubgrbN6Z8b59u+E7q6/P8eV5x/JyAl18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708702332; c=relaxed/simple;
	bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W1XliHXj1C9ujUJvv4nC2bIi+FWV8x4sR5cAt2oG35bgmXg5tL5tR/SK4RpL/MQTtEWLlCbcCMR1XM3YgqVXchqOKnoK1wK1+/PaNOukUeS7SlnhLvgUlxmtMffQ2gZ3YB+SQR7pT1MrYXzOeHW41L9YDxS63mGgOSUoOMnzFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y5gDWO71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5gDWO71"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708702329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
	b=Y5gDWO713ZR9FvJq9wuF+JXDoCMfBC6gWYrhtjWKpYfYxw9fndlnyH1ZPf/vhFyZTQO2VL
	zIdRK0IihCeE1GGx7gOj/fSBFndatbFZ21MvM1/Evn4LJsqA/swtSAmrOeLIR2peFN1Wuw
	/bIbMzldyI0iwILvOTsVH6380gZgJgA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-eP_C0HVkNB-HDEghIon5Rw-1; Fri, 23 Feb 2024 10:32:08 -0500
X-MC-Unique: eP_C0HVkNB-HDEghIon5Rw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d4c09ec04so513691f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 07:32:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708702327; x=1709307127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
        b=uQ9DJAwhstLEPpuNI/5nlzrjbep+4yWVM4SfGMCBgcb34QeEIjqGH7fSqCzxUAEPlU
         HnE7Qm9PwHfyeWjxt7QDuKjosUU1/O8xtT23m8E8vahhfzsD0SfsHTvMWczq0xCjVKGP
         loHGAZNQhIirxsQEvFlHaKen2k0uR2fhZ/JI1hkHMchqXjWTII/4u2a7SoxIUjj0vcWe
         hCj4GydfGLf2L1tGpW0SHdDOUA8osf/scewEMuYFQmmxlnCPciXHk1UtSvVrQi0UjBuj
         +xP+nPnz5nGODDVZJ0rB4P7YYCTlifTNO7qdFJgfWtVc+uAO5VRi0k+bD/C442pbzXmY
         BPOA==
X-Forwarded-Encrypted: i=1; AJvYcCVqDONrG4KG1m2LPIC3nOzCQmfUhw5cQ7OQE2JL2wq68rDUYs6A6qU2rdODqoq/hhz1DCUeFC0xKXh+NDjrJtFoNi88WTMl
X-Gm-Message-State: AOJu0YzHcPBuxaAV2AXLhXM+N1wqdBBn1cHkpQ0Wn8K3iUysv6CFPel/
	pOEjhsn4BTQO0vLepJOGbPLUf0fu1bLkso2oE/BJW1xCe7DYUEQ8tHPub6BzKWuZCDl0/J8k71E
	J5Ku2iAKkSueRtwurCU1OAfwY0i7VJwvFoXfaFIGzm1x9eJPW1sWN8Soa24Wn50l3su8Bj87c2f
	uRpqZWOAi4Vs3OB9p88+hpMK5P3ykk
X-Received: by 2002:adf:e511:0:b0:33d:5ae5:f356 with SMTP id j17-20020adfe511000000b0033d5ae5f356mr94667wrm.20.1708702327609;
        Fri, 23 Feb 2024 07:32:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLm2G66Tw4sgodVUIb9Jzv+TjNHaof3FgriahBQfesSvJsXof4hqEVZ82kEIdVUXv/1jq4kYYkRea+6qJNwbM=
X-Received: by 2002:adf:e511:0:b0:33d:5ae5:f356 with SMTP id
 j17-20020adfe511000000b0033d5ae5f356mr94647wrm.20.1708702327323; Fri, 23 Feb
 2024 07:32:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240216155941.2029458-1-oliver.upton@linux.dev>
In-Reply-To: <20240216155941.2029458-1-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Feb 2024 16:31:55 +0100
Message-ID: <CABgObfYZBnTjXh4TqH77HjO3zTMRfekaorTUVqQoFOMPJLjJTg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, 
	Sean Christopherson <seanjc@google.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Sebastian Ene <sebastianene@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 5:00=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> The general expectation with debugfs is that any initialization failure
> is nonfatal. Nevertheless, kvm_arch_create_vm_debugfs() allows
> implementations to return an error and kvm_create_vm_debugfs() allows
> that to fail VM creation.
>
> Change to a void return to discourage architectures from making debugfs
> failures fatal for the VM. Seems like everyone already had the right
> idea, as all implementations already return 0 unconditionally.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Feel free to place it in kvm-arm.

Paolo

