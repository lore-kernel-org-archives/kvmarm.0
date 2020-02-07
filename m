Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1B1C04EB5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:09:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DB20838
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GfvXAHT7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F8DB20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8DFA4A389;
	Fri,  7 Feb 2020 11:09:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FZE1Q6Yre8+m; Fri,  7 Feb 2020 11:09:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5EF94A523;
	Fri,  7 Feb 2020 11:09:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 201B74A51F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:09:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vouvRtBeh-Bv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:09:16 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0EA4A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:09:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581091756;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7N0tYww3cTYTuDfUVu7cVEqlKJlOXVPc3ePTt6l3bR0=;
 b=GfvXAHT7FeTrjCXETplPTSwWUDA3WITLMTztQs4tCMUuZNzj5UiaMAN+208dpVncUQjE4p
 znDSYIlLfzHX9IBWmLQqE08BsrxDfSoruLa0lVoNbMdgaR5oNOhZ88G28B6VnW0iYYQgN0
 YU4Pxi+CJXx81wGffKVFgMhJhkbyKVI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-H5eztlYeMRe-BNPDJ556AQ-1; Fri, 07 Feb 2020 11:09:13 -0500
Received: by mail-wr1-f72.google.com with SMTP id j4so1482123wrs.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 08:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GPX7KhocVFe6HD6YL/9rJK/zg2VMIEIUiI5Ny18HODk=;
 b=txVYXPXTV7kSaBPsk/51SMDv66JEyFh3w9+eq8rUzL8H7W6i+juVJuvWv5EcPQC2iX
 IGk+KcPOF2ME6CvJDyltWdvokVyxJFMTUDGfAysgAPYXRthz71LsAR0qEX45DTXCfDon
 WHTxEahwWcGL/QJOpATcPOdr4zpkLw65Y7fU0IfNrj7ckdUkmPnQg7dzZ31gAqmLQ8KS
 vlkv7/hIY5GfgaXnmq09qGqLeY/ftVm8IK07AfTIkzpEJ8pfxX+EXrxezS+bb23rQ3IE
 SvibvrwA7T+oJ6+5Qtyr1jpqoEIHcqwERdkPQ0QL8EHb/xwrTfoz+6cadcEo+WrEBP0u
 Bnfg==
X-Gm-Message-State: APjAAAX6hYDI/MV2rC2K+EBj/khj0sBtuXGUMq/EhxKQzdH6j0q2DO2S
 8RAmBVOXWX/xJkkpI2MRh0WCtmiwFQwWb1zcCQhUvAuCMbcxJV9jEI9Hee0tnrLzZvMtF9I0bgp
 9ESz5y3FtXvj54zn1w8zu3YChTESQzbvnmThbgxvj
X-Received: by 2002:adf:81c2:: with SMTP id 60mr5326228wra.8.1581091752430;
 Fri, 07 Feb 2020 08:09:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8i+O+y5j4ffE/kZCvgNUkhocxxUdJSS6Q88cwkQL2oV7RB4nr38cQmC5SN1dH7PhgmbXS5s8Jiuxotyz6JIo=
X-Received: by 2002:adf:81c2:: with SMTP id 60mr5326202wra.8.1581091752153;
 Fri, 07 Feb 2020 08:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com> <20200207160546.GA707371@xz-x1>
In-Reply-To: <20200207160546.GA707371@xz-x1>
From: Peter Xu <peterx@redhat.com>
Date: Fri, 7 Feb 2020 11:09:01 -0500
Message-ID: <CADLectmX7JOpzbr_BdpM+i8=T7PE-5fiedkg3jgzH6SvVbbrQg@mail.gmail.com>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-MC-Unique: H5eztlYeMRe-BNPDJ556AQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
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
Content-Type: multipart/mixed; boundary="===============4644268902396989493=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4644268902396989493==
Content-Type: multipart/alternative; boundary="0000000000003eb245059dfe9ca5"

--0000000000003eb245059dfe9ca5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2020 at 11:05 AM Peter Xu <peterx@redhat.com> wrote:

> Reviewed-by: Peter Xu <peterx@redhat.com>


(Maybe also after we figure out the "[]" & "[0]" issue to make sure it
won't fail for newer gcc)

--0000000000003eb245059dfe9ca5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:courier new,monospace;font-size:large"><span style=3D"font-family:=
Arial,Helvetica,sans-serif;font-size:small">On Fri, Feb 7, 2020 at 11:05 AM=
 Peter Xu &lt;<a href=3D"mailto:peterx@redhat.com">peterx@redhat.com</a>&gt=
; wrote:</span><br></div></div><div class=3D"gmail_quote"><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
Reviewed-by: Peter Xu &lt;<a href=3D"mailto:peterx@redhat.com" target=3D"_b=
lank">peterx@redhat.com</a>&gt;</blockquote><div><br></div><div class=3D"gm=
ail_default" style=3D"font-family:&quot;courier new&quot;,monospace;font-si=
ze:large">(Maybe also after we figure out the &quot;[]&quot; &amp; &quot;[0=
]&quot; issue to make sure it won&#39;t fail for newer gcc)</div></div></di=
v>

--0000000000003eb245059dfe9ca5--


--===============4644268902396989493==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4644268902396989493==--

