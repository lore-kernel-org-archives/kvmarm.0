Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7558C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 18:03:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4291A20809
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 18:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdtV3pHJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4291A20809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED7E4B372;
	Thu, 30 Jul 2020 14:03:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lD+UQ+-YvxVD; Thu, 30 Jul 2020 14:03:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BB64B378;
	Thu, 30 Jul 2020 14:03:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D18DA4B371
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 14:03:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YGbMrfWxo+yz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 14:03:44 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E924B370
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 14:03:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596132224;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Llr3jbX4+eQbCMXahehf7lRhdsVOcRJtF7awLuCBofM=;
 b=VdtV3pHJ8hCkeHNe+XuDkTU3XeDlyE9W6sgWpUVLIASSTJrkoFL5hXdHLwr4+3+raiIC+o
 mrCGI7oCO0rhVvs5zpMpJoH+bcGDrEkq1tlJV5dFfAQzQKocl1PlIZI8yTi+I7EvsLlrLR
 /uPYL4IPpjF0ydQQfe7nIOLUX5xGRNM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-mGzra2OPNOi-mE5d4b7t3g-1; Thu, 30 Jul 2020 14:03:41 -0400
X-MC-Unique: mGzra2OPNOi-mE5d4b7t3g-1
Received: by mail-ed1-f69.google.com with SMTP id b23so7531212edt.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Llr3jbX4+eQbCMXahehf7lRhdsVOcRJtF7awLuCBofM=;
 b=KlZcWAERQDltSAO6VyzcmQcxrL7BfJV/QNqLNw6hS6DXWT0/kqVnxJn6sM3SDtdvGA
 vYzFvi+pAUSnjnTiXWwTzMnbbWmf/s+iMTb1F4DZwEk5y1u8SEDwdPlQKksVOdjHD7qD
 dXXzfSf0jQCyoUMzy5Y0pLU2MBR89D1lME/cLE0BIrvhMXn3GF2U51n1YLuHjx4pcFvX
 dr6t7oU045xUnB3B/B6jalKCcFMtJVa2Lv0zFIvKZblw8zzGwGVllWrMWzDUuZth8wcL
 B3maY44msSixhK83VWoz9jCtjrGZGr+uyLI/3ww2lVJ6YYROqy0CA2gTDjYeUR9oJyLQ
 uMtg==
X-Gm-Message-State: AOAM532pAvqNN8xQIECgWzQiJURNBEIE/r3A+/m4gCiZITzQB6tWLRDt
 z2nYrUY0vyQdOHomBkhUMm35Oe4X9cT8eesZ7YHGXQd+rT8TPGL2oMzRIcxaaHN2lO2t9R4Rg0i
 100mhoVnYpPC/88maAhkg06N+esxC8hynz26BR/Co
X-Received: by 2002:a17:906:68b:: with SMTP id
 u11mr290757ejb.143.1596132220645; 
 Thu, 30 Jul 2020 11:03:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4enFU4uhX+r96D2QgTQtFnDcv/m7rBw4njfzVvKKa+ClF5F6bxBstpOGEsJHpeumldR3zP1g5p1cQXhBFmyQ=
X-Received: by 2002:a17:906:68b:: with SMTP id
 u11mr290731ejb.143.1596132220464; 
 Thu, 30 Jul 2020 11:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
In-Reply-To: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 30 Jul 2020 20:03:28 +0200
Message-ID: <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To: Zhenyu Ye <yezhenyu2@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, "S. Tsirkin,
 Michael" <mst@redhat.com>, linux-kernel@vger.kernel.org, ghaskins@novell.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============4328379399695583718=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4328379399695583718==
Content-Type: multipart/alternative; boundary="000000000000040e1305abac7eda"

--000000000000040e1305abac7eda
Content-Type: text/plain; charset="UTF-8"

Yes, I think it's not needed. Probably the deassign check can be turned
into an assertion?

Paolo

Il gio 30 lug 2020, 16:36 Zhenyu Ye <yezhenyu2@huawei.com> ha scritto:

> Hi all,
>
> There are checks of ioeventfd collision in both kvm_assign_ioeventfd_idx()
> and kvm_deassign_ioeventfd_idx(), however, with different logic.
>
> In kvm_assign_ioeventfd_idx(), this is done by ioeventfd_check_collision():
> ---8<---
>         if (_p->bus_idx == p->bus_idx &&
>             _p->addr == p->addr &&
>             (!_p->length || !p->length ||
>              (_p->length == p->length &&
>               (_p->wildcard || p->wildcard ||
>                _p->datamatch == p->datamatch))))
>                 // then we consider the two are the same
> ---8<---
>
> The logic in kvm_deassign_ioeventfd_idx() is as follows:
> ---8<---
>         if (p->bus_idx != bus_idx ||
>             p->eventfd != eventfd  ||
>             p->addr != args->addr  ||
>             p->length != args->len ||
>             p->wildcard != wildcard)
>                 continue;
>
>         if (!p->wildcard && p->datamatch != args->datamatch)
>                 continue;
>
>         // then we consider the two are the same
> ---8<---
>
> As we can see, there is extra check of p->eventfd in
>
> ().  Why we don't check p->eventfd
> in kvm_assign_ioeventfd_idx()? Or should we delete this in
> kvm_deassign_ioeventfd_idx()?
>
>
> Thanks,
> Zhenyu
>
>

--000000000000040e1305abac7eda
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Yes, I think it&#39;s not needed. Probably the deassign c=
heck can be turned into an assertion?<div dir=3D"auto"><br></div><div dir=
=3D"auto">Paolo</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">Il gio 30 lug 2020, 16:36 Zhenyu Ye &lt;<a href=3D"mai=
lto:yezhenyu2@huawei.com">yezhenyu2@huawei.com</a>&gt; ha scritto:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">Hi all,<br>
<br>
There are checks of ioeventfd collision in both kvm_assign_ioeventfd_idx()<=
br>
and kvm_deassign_ioeventfd_idx(), however, with different logic.<br>
<br>
In kvm_assign_ioeventfd_idx(), this is done by ioeventfd_check_collision():=
<br>
---8&lt;---<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (_p-&gt;bus_idx =3D=3D p-&gt;bus_idx &amp;&a=
mp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _p-&gt;addr =3D=3D p-&gt;addr &am=
p;&amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!_p-&gt;length || !p-&gt;length =
||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(_p-&gt;length =3D=3D p-&gt=
;length &amp;&amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (_p-&gt;wildcard || p-&gt;=
wildcard ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0_p-&gt;datamatch =3D=
=3D p-&gt;datamatch))))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // then we consider=
 the two are the same<br>
---8&lt;---<br>
<br>
The logic in kvm_deassign_ioeventfd_idx() is as follows:<br>
---8&lt;---<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p-&gt;bus_idx !=3D bus_idx ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;eventfd !=3D eventfd=C2=A0 =
||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;addr !=3D args-&gt;addr=C2=
=A0 ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;length !=3D args-&gt;len ||=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;wildcard !=3D wildcard)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!p-&gt;wildcard &amp;&amp; p-&gt;datamatch =
!=3D args-&gt;datamatch)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 // then we consider the two are the same<br>
---8&lt;---<br>
<br>
As we can see, there is extra check of p-&gt;eventfd in<br>
<br>
().=C2=A0 Why we don&#39;t check p-&gt;eventfd<br>
in kvm_assign_ioeventfd_idx()? Or should we delete this in<br>
kvm_deassign_ioeventfd_idx()?<br>
<br>
<br>
Thanks,<br>
Zhenyu<br>
<br>
</blockquote></div>

--000000000000040e1305abac7eda--


--===============4328379399695583718==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4328379399695583718==--

