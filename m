Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8049ECAAD2
	for <kvmarm@archiver.kernel.org>; Mon, 29 Aug 2022 10:27:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2DE4B2B0;
	Mon, 29 Aug 2022 06:27:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u-h-3DWuy5Bw; Mon, 29 Aug 2022 06:27:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7236A4C477;
	Mon, 29 Aug 2022 06:27:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A944B2B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 06:27:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hWaWq35GioIE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2022 06:27:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DE84A104
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 06:27:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661768849;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UWhgpt4Fhixe/Fx8cfj8VGfC4lf1XLxWUyJHW5E3ni4=;
 b=WUUkAwVS+QXez0KK2nWg4LLoqY/jY41cXUicw7iJzKTb2F11+n9TZSu1vUwjftrxQcEk39
 I/OXw5rxs1CRYCQiRILZUWHu3vuMU5i8lTYlDz8Qv5jGA215jvKNWSK0phwrw5he3zdc3d
 mFmlRbl3vQAPdqg1r16onlqkI3Roa64=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-146-L2RcffaBMhOBm8g0vpdRiw-1; Mon, 29 Aug 2022 06:27:28 -0400
X-MC-Unique: L2RcffaBMhOBm8g0vpdRiw-1
Received: by mail-lf1-f70.google.com with SMTP id
 f9-20020ac24989000000b0049306244df2so1943265lfl.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 03:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=UWhgpt4Fhixe/Fx8cfj8VGfC4lf1XLxWUyJHW5E3ni4=;
 b=5YajxfZhxznqTS+6klMNZy2K3KdJdy/G4i1mFA88vbh4dzPpXqqXeGYyjyL4muV0OL
 IKXlFD8zlR+t8B9LoIgfezV/D0LDYZ6Dep6mInS7jOTleY4AyLr6qQFcZz5FDNTcaK6t
 9hD7z3cnvoEgxRfhy4UaMJZ1wWVVjEXgQfjJEC77wAkc8/37Jb4xiU2zVMcjRaRQDK1O
 MYAthJ0OoxIJBrZxBe1VjAiOhq6rpO+/8oayyrwQNP/p5wfkBgSm1z6hAwOlTANfA7ar
 9VVDqo9W0rEpAdKiHF1eyDI6M15z/v/eAZRaFWXoSs8S0yqOB6hQ6WQ/KXI+ywsxa7As
 gXFA==
X-Gm-Message-State: ACgBeo1YCRyg3I4CyuM94UhbEA1EkYB63JAWWSnwWV1Ps3ydk8I5bf4V
 aJKlUM/ZGw3JJQAvDhbHNwN1Ok1SVE78d2eJmnPSVQfT9mYTpFamJ6oA9sP7Dz7rOPAV0HvnKsY
 0NH4rNvF+ZuGM8EwWqmYPCZ3rq+w1X5DojdViD49M
X-Received: by 2002:a05:6512:b12:b0:492:8943:c813 with SMTP id
 w18-20020a0565120b1200b004928943c813mr5729466lfu.143.1661768846877; 
 Mon, 29 Aug 2022 03:27:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4hdDhdjssScLDR7nz8UcPKJKwyQkWmyGccxgCuLIp73x7+rLd9nENWLPrth3LAUnUd/J3ZIN1zm4d4an+Ux0E=
X-Received: by 2002:a05:6512:b12:b0:492:8943:c813 with SMTP id
 w18-20020a0565120b1200b004928943c813mr5729440lfu.143.1661768846598; Mon, 29
 Aug 2022 03:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local> <87bksawz0w.wl-maz@kernel.org>
 <YwVEoM1pj2MPCELp@xz-m1.local> <878rnewpaw.wl-maz@kernel.org>
 <9e7cb09c-82c5-9492-bccd-5511f5bede26@redhat.com>
 <8735djvwbu.wl-maz@kernel.org>
In-Reply-To: <8735djvwbu.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 29 Aug 2022 12:27:07 +0200
Message-ID: <CABgObfaeJ-0Gz7ACgkcmR0pdTH02snB25J+=u1vGG-N-AOkVDw@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm <kvm@vger.kernel.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 Ben Gardon <bgardon@google.com>, Shuah Khan <shuah@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, Jonathan Corbet <corbet@lwn.net>,
 Will Deacon <will@kernel.org>, Shan Gavin <shan.gavin@gmail.com>,
 Zhenyu Zhang <zhenyzha@redhat.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, "Kernel Mailing List,
 Linux" <linux-kernel@vger.kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1627397539142428809=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1627397539142428809==
Content-Type: multipart/alternative; boundary="000000000000cd00d905e75eb522"

--000000000000cd00d905e75eb522
Content-Type: text/plain; charset="UTF-8"

Il ven 26 ago 2022, 17:50 Marc Zyngier <maz@kernel.org> ha scritto:

> userspace has no choice. It cannot order on its own the reads that the
> kernel will do to *other* rings.
>
> The problem isn't on CPU0 The problem is that CPU1 does observe
> inconsistent data on arm64, and I don't think this difference in
> behaviour is acceptable. Nothing documents this, and there is a baked
> in assumption that there is a strong ordering between writes as well
> as between writes and read.
>

Nevermind, what I wrote last Saturday doesn't make sense. I will try to put
together a litmus test but IMO the synchronization is just between
userspace and kernel, because the dirty page ring is essentially two ring
buffers in one. The actual producer of dirty pages is a red herring.

I am HTML-only for a couple days, I will resend to the mailing list on
Thursday.

Paolo

>

--000000000000cd00d905e75eb522
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">Il ven 26 ago 2022, 17:50 Marc Zyngier &lt;<a href=3D"=
mailto:maz@kernel.org">maz@kernel.org</a>&gt; ha scritto:<br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">userspace has no choice. It cannot order on its own =
the reads that the<br>
kernel will do to *other* rings.<br>
<br>The problem isn&#39;t on CPU0 The problem is that CPU1 does observe<br>
inconsistent data on arm64, and I don&#39;t think this difference in<br>
behaviour is acceptable. Nothing documents this, and there is a baked<br>
in assumption that there is a strong ordering between writes as well<br>
as between writes and read.<br></blockquote></div></div><div dir=3D"auto"><=
br></div><div dir=3D"auto">Nevermind, what I wrote last Saturday doesn&#39;=
t make sense. I will try to put together a litmus test but IMO the synchron=
ization is just between userspace and kernel, because the dirty page ring i=
s essentially two ring buffers in one. The actual producer of dirty pages i=
s a red herring.</div><div dir=3D"auto"><br></div><div dir=3D"auto">I am HT=
ML-only for a couple days, I will resend to the mailing list on Thursday.</=
div><div dir=3D"auto"><br></div><div dir=3D"auto">Paolo</div><div dir=3D"au=
to"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
</blockquote></div></div></div>

--000000000000cd00d905e75eb522--


--===============1627397539142428809==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1627397539142428809==--

