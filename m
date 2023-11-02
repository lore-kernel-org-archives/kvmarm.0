Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9051219F1
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 20:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtfbnVHr"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-581e92f615fso650006eaf.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698956788; x=1699561588; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1/c+9q5F6vJQGdeK3GAV6RYW5UxuwtB/kEmZPd/ZYM=;
        b=CtfbnVHrIFRop83O7lKqiU0WyHlrvGAFk/o7lsAGYqHH08bHCvozsHctuGzAVt+FBL
         zaFCHoK6Yxx7xGu1wBw36gakOXJJ77LJUsBi1f4h4JKA2u+9dSzHykuGMYjuBj/0stDU
         l4rHCrFlM/fih7trbqhgUIhJ+JDpseLRrH3MQnCYMPCUBj1Jb5bJ3uPmS472ul8j+nHJ
         SuXWaT3WCzNhxVYZp1o4nL+g45oN3nsn5icQiTsT0wdfyZjzIHU1j5yDDOx22r21hW2h
         B5wYr0HlpDDewV7a/3c3g72xWDhh4ixwjZ1BdbawSEQN+l0OxemMy4oxSU2VpU2k8jcJ
         UN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698956788; x=1699561588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1/c+9q5F6vJQGdeK3GAV6RYW5UxuwtB/kEmZPd/ZYM=;
        b=kbksUxBzuTrxbXu3czHihnCsuVM1dGInCYJoyTyVVb1SX6epxJZsY8c1yiZa/D7whN
         yCUIeWLMKe2IyATVxGqDKQRc/Xi4dyPFZf1JwVocc5UjNMtkbQ8LOe2q0vQxUrg8Jq3F
         mX1t46u8qg1X0RucbJUtrINC6qTc2eEkeo5RXgh6hZcJv2FfxzBTYBinQfPl/j42CYwV
         AtysVOhGmogkhoFjWdad6f6aPRr21KcjQ7H7kXA3PRhhLKSDrwFBuMM7/ceONhz2C6yi
         q4cNEY9u2NrZJRQDznJxAjQHEVhIXXfDfKUH/sT8gw8qPYIkGxLmtju1NReC/7FKnQC0
         Clng==
X-Gm-Message-State: AOJu0YyySp91XVEN7/ilDrqzJsoNBVg1oTsvAF1VtMYioNhpT+dIaO7R
	wAljhijlH/+NKjOid61O/slXClz4IKeduk+UtDeZUg==
X-Google-Smtp-Source: AGHT+IGcJQISXG+9qweii6J9T8ORXystyQe8U0Ulfs0xdHraAqZIk9sNe6Gy6mhMMudgW60cCnOsGw5yUb8GwFD6DzE=
X-Received: by 2002:a4a:e28a:0:b0:581:ed9a:4fde with SMTP id
 k10-20020a4ae28a000000b00581ed9a4fdemr19465482oot.1.1698956787854; Thu, 02
 Nov 2023 13:26:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
In-Reply-To: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 2 Nov 2023 13:25:51 -0700
Message-ID: <CAF7b7mow10g_T=vocu6jaXsUciEPyu79X2HuCWuSLgqBcFL2ZA@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 2, 2023 at 12:14=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> Proposed commit message for the squashed commit
>
> > KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 f=
ault handlers

Erm, I seem to have flubbed it already. IIRC this should be
"vcpu-context accesses," not "stage-2 fault handlers"
