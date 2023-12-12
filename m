Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3FD61FAF
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 13:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnnrM/oj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702388297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IjtSLSS+KMn2n0R4fQtLvtCI4SQNSXOvC4z09ahOFQ=;
	b=QnnrM/ojkQbotVaRI7gB8Obp3cWqBXS+M/DLubLAxsMccXdsu3QAhaD/eJ0nMfSSahs7VV
	V5nmMfxOEitoseQviDMqaPZpq8vF6y8l6UuDOEOxCTXZ4JM3sEezusI+CPhIhgeIBtMPqx
	k2xgasMcfK8U8LPUrh94/JMpPFOk4Uo=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-pNj9vbCoNPCEuLE-LI7jFg-1; Tue, 12 Dec 2023 08:38:16 -0500
X-MC-Unique: pNj9vbCoNPCEuLE-LI7jFg-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7cb13418162so381090241.3
        for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 05:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702388295; x=1702993095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IjtSLSS+KMn2n0R4fQtLvtCI4SQNSXOvC4z09ahOFQ=;
        b=exIozulHZeInNaP7GcUmK3Fita35xpg8xQNctIHj2FpaBHYc+vwpxJphY8aPSlHztU
         HR/CZIR/Eqj+hj/0D+R/szBafifkkEDeNRtEB+Fw5xfg8nG+OZ83A42mMFbJgK+MiMG5
         h71foOX05jCsCSNBnUO2ubcazrVcczj6Pt0zXBue8VUxIyE4TH4dKTdDp3fs8qshabpm
         rjI3DUki3Dm6BW1242ieihICFOd6gTPlFeS6kQVPJbRn0YMU/tvGbvsElcswBa7yPELy
         r5w61TwOrxx7eMfB3KXKPzB9bSoK9RDra2E9i6vNbjSI/qb59S8eiXCtXZQazN3QrgoI
         t8dQ==
X-Gm-Message-State: AOJu0YxfVp6cz62Uqw0wNUQctpt4F7jY1VqEB6zRl7Op///0/3bPOfvH
	jumNoYnk/VZ+0CuO4z+txP234fO040fBBxipQNeYzl7aqK9mBOqWONdYlTZSO+nreYC9qYEHkRd
	W381DsbfBG5cTfCXA+svXz1jw7FR9GblA
X-Received: by 2002:a05:6102:954:b0:464:a4b9:5ca2 with SMTP id a20-20020a056102095400b00464a4b95ca2mr4133773vsi.43.1702388295552;
        Tue, 12 Dec 2023 05:38:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoi0rzc6o7Gt4+TFEGhMVoc3vZ6tzwUFixtpjFgOfHf47vt6vk5agyXIEXqqQZSIqeGr8AylCCZagp/mgF4KI=
X-Received: by 2002:a05:6102:954:b0:464:a4b9:5ca2 with SMTP id
 a20-20020a056102095400b00464a4b95ca2mr4133761vsi.43.1702388295319; Tue, 12
 Dec 2023 05:38:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com> <20230512233127.804012-2-seanjc@google.com>
 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
 <871qbud5f9.fsf@email.froward.int.ebiederm.org> <a02b40d3d9ae5b3037b9a9d5921cfb0144ab5610.camel@amazon.com>
 <7e30cfc2359dfef39d038e3734f7e5e3d9e82d68.camel@amazon.com>
 <87wmtk9u46.fsf@email.froward.int.ebiederm.org> <cf9e15bf3da411ada1c5b2bbdbfdea836029a5e1.camel@amazon.com>
In-Reply-To: <cf9e15bf3da411ada1c5b2bbdbfdea836029a5e1.camel@amazon.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 12 Dec 2023 14:38:02 +0100
Message-ID: <CABgObfZKOkUn3++g-YMkv7bsmKU77Y88NPBqt-5XoRJFLXDEFA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
To: "Gowans, James" <jgowans@amazon.com>
Cc: "Graf (AWS), Alexander" <graf@amazon.de>, "seanjc@google.com" <seanjc@google.com>, 
	"ebiederm@xmission.com" <ebiederm@xmission.com>, =?UTF-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>, 
	"anup@brainfault.org" <anup@brainfault.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 9:51=E2=80=AFAM Gowans, James <jgowans@amazon.com> =
wrote:
> 1. Does hardware_disable_nolock actually need to be done on *every* CPU
> or would the offlined ones be fine to ignore because they will be reset
> and the VMXE bit will be cleared that way? With cooperative CPU handover
> we probably do indeed want to do this on every CPU and not depend on
> resetting.

Offlined and onlined CPUs are handled via the CPU hotplug state machine,
which calls into kvm_online_cpu and kvm_offline_cpu.

Paolo

