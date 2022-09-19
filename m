Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E976EECAAD3
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 20:01:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578A64B64F;
	Mon, 19 Sep 2022 16:01:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GSZU-FBWNl-j; Mon, 19 Sep 2022 16:01:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DBD84B651;
	Mon, 19 Sep 2022 16:01:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FE84B64F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 16:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yWPLGjot9nN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 16:01:20 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC0554B64E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 16:01:19 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id
 o99-20020a17090a0a6c00b002039c4fce53so3022324pjo.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date;
 bh=d2mOaXqBJ/J1NiBq+p9zZqqA3x7aa90eBHG5Ll0Tfso=;
 b=fdaJHOO3a2pIOR/89fIgJSQloU9jbVrOA5QbPQYMMYhLs8KoKEqyaQOH63NzdC0BW5
 +xcbWp6DgPQyD8KWK1F+0hqGEOAMaJii6EDQQ+46c4Vd6yCQMokwDddgQ8ZRmNmB2qCs
 ulnhQ8DScLVB8wgMjAj1Ot2sozJegDbvU71kckRVcEkytQ86MIyC0t93pWLCWTc0/+FT
 Fr2cnmgIKc5F13hwz8ScnRXqeavbLJ/pD7MdUlOTgYtEbfeVqq21kIsvObKkjYsZcA/h
 kAWquL8pPjpQSqAdLOxChyzTrLQxPuxT1NG9TyizytbwW9o8YN5N9fj5PtmjQ/KPwAiL
 dwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date;
 bh=d2mOaXqBJ/J1NiBq+p9zZqqA3x7aa90eBHG5Ll0Tfso=;
 b=Qv6oZwU79W2Ya/RdS9ALcXTR5JlDiFM28R4HCaGQAkVNSGpTU7yJVxrCyG1uMBp6sC
 Y/ZQmV83wXfiW/zne6Bhbd++tHnRZufSGo2wErLM7TNePxxrVMLy9vWQ0yKapM5Znw5S
 5OfYBpV7kKId3E37PovHLXqHhDdKGx/AIqpuR3S7fPvcSHM1yv450gdmtMmaY2eoBtKl
 OkI4lqP+mOIon3rrSQFCgQ5tL6+ugtan8aVPtTFB4zAU+qfoEydEQte2BkESJyTSv8sI
 mgd9VdYiT2odrUFWEpKQWhykiFemxAGNWjvnQSDlc3BCVidjSOI3MyPJAjOLqq8QiQq2
 zfxw==
X-Gm-Message-State: ACrzQf0VH/yqrBo0vYUQhvK3o5LowLzVuB5StwHnnkttsvQK1o8E6tac
 hIF6xbCK0ERnvCg/HpOiMQYwjw==
X-Google-Smtp-Source: AMsMyM7ekM/QpjauHVnjWvyDT4Y/ZpvdxNLs+apfRnU6iIqW4hyA8I00zbHqV8xMsYofHJnxlgrT4Q==
X-Received: by 2002:a17:902:cec9:b0:178:1da5:1075 with SMTP id
 d9-20020a170902cec900b001781da51075mr1403934plg.136.1663617678958; 
 Mon, 19 Sep 2022 13:01:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 w1-20020a1709026f0100b00178650510f9sm10750215plk.160.2022.09.19.13.01.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 13:01:18 -0700 (PDT)
Date: Mon, 19 Sep 2022 20:01:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyjKir3OGCfFvAsy@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
 <YyZDBIQsux1g97zl@google.com> <YyjDCWCJ5j8c6T2h@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyjDCWCJ5j8c6T2h@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gTW9uLCBTZXAgMTksIDIwMjIsIFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+IE9uIFNhdCwgU2Vw
IDE3LCAyMDIyIGF0IDA5OjU4OjI4UE0gKzAwMDAsIE9saXZlciBVcHRvbiB3cm90ZToKPiA+IEBA
IC01MzYsMTMgKzUzNiw3IEBAIHN0YXRpYyB2b2lkIGxvYWRfZXhlY19jb2RlX2Zvcl90ZXN0KHN0
cnVjdCBrdm1fdm0gKnZtKQo+ID4gIAlhc3NlcnQoVEVTVF9FWEVDX0dWQSAtIFRFU1RfR1ZBKTsK
PiA+ICAJY29kZSA9IGh2YSArIDg7Cj4gPiAgCj4gPiAtCS8qCj4gPiAtCSAqIFdlIG5lZWQgdGhl
IGNhc3QgdG8gYmUgc2VwYXJhdGUgaW4gb3JkZXIgZm9yIHRoZSBjb21waWxlciB0byBub3QKPiA+
IC0JICogY29tcGxhaW4gd2l0aDogIuKAmG1lbWNweeKAmSBmb3JtaW5nIG9mZnNldCBbMSwgN10g
aXMgb3V0IG9mIHRoZSBib3VuZHMKPiA+IC0JICogWzAsIDFdIG9mIG9iamVjdCDigJhfX2V4ZWNf
dGVzdOKAmSB3aXRoIHR5cGUg4oCYdW5zaWduZWQgY2hhcuKAmSIKPiA+IC0JICovCj4gPiAtCWMg
PSAodWludDY0X3QgKikmX19leGVjX3Rlc3Q7Cj4gPiAtCW1lbWNweShjb2RlLCBjLCA4KTsKPiA+
ICsJKmNvZGUgPSBfX2V4ZWNfdGVzdDsKPiAKPiBJIHJlbWVtYmVyIHRyeWluZyBtYW55IHdheXMg
b2YgZ2V0dGluZyB0aGUgY29tcGlsZXIgdG8gbm90IGNvbXBsYWluLCBJCj4gbXVzdCBoYXZlIHRy
aWVkIHRoaXMgKHdvbmRlciB3aGF0IGhhcHBlbmVkKS4gQW55d2F5LCBnY2MgYW5kIGNsYW5nIGFy
ZQo+IGhhcHB5IHdpdGggaXQuCgpBbHRlcm5hdGl2ZWx5LCBmcm9tIGEgY29kZSBkb2N1bWVudGF0
aW9uIHBlcnNwZWN0aXZlIGl0IHdvdWxkIGJlIG5pY2UgdG8gY2FwdHVyZQp0aGF0IHRoZSBzaXpl
IGlzbid0IGFyYml0cmFyeS4gIEUuZy4KCiAgdHlwZWRlZiB1aW50MzJfdCBhYXJjaDY0X2luc25f
dDsKCiAgZXh0ZXJuIGFhcmNoNjRfaW5zbl90IF9fZXhlY190ZXN0WzJdOwoKICB7Cgl2b2lkICpj
b2RlOwoKCW1lbWNweShjb2RlLCBfX2V4ZWNfdGVzdCwgc2l6ZW9mKF9fZXhlY190ZXN0KSk7CiAg
fQoKTm90ZSwgbWVtY3B5KCkgaXMgY3VycmVudGx5IGRhbmdlcm91cywgYnV0IGhvcGVmdWxseSB0
aGF0IHdpbGwgYmUgcmVtZWRpZWQgc29vbmlzaFsqXQoKWypdIGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC8yMDIyMDkwODIzMzEzNC4zNTIzMzM5LTEtc2VhbmpjQGdvb2dsZS5jb20KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
