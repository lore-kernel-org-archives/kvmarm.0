Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEAFC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 14:32:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C3C49EF4;
	Mon, 14 Mar 2022 10:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HD3uMbT3mTjr; Mon, 14 Mar 2022 10:32:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E841349E17;
	Mon, 14 Mar 2022 10:32:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B0648F9C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 10:32:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kh80DL6lQmV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 10:32:33 -0400 (EDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88CF040BF0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 10:32:33 -0400 (EDT)
Received: by mail-yw1-f175.google.com with SMTP id
 00721157ae682-2db2add4516so166184267b3.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 07:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=9RB3c+6E1iaZmcllyzPO9tW2v+xcuDh9lXJfmhX4wpM=;
 b=LeGuYouBKMGj9xSTMEyIMw/4kXhe3dVE85e4RbEfM3BfLpUnwXJLJIFBQ8ePacgEuu
 fN2lDYJCJu7NCqNSzTXX0RQtBvLEbsP329oD5r9GA8v1killY1BOD4MDcXPbJp/thFmw
 RFiB+Y/cn+AxJy9hE+2ouHB19GaID5B3TJ8r9VyDu6V50YzD3gg5hnVUTrpfFXdxCXLi
 X7hXzD5+0xceP+LfOR9MA4BTpUTqvtqsTMkIjP3s/0ycsbP2H2tpapMAYbK3B6pibv/O
 3Bgg7Wmh2XptJ/MK25iEo8GfS/t3PyTEu1KTRT7vjywDa1uT3KVZR1KCugfneSkHbQ7n
 MPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=9RB3c+6E1iaZmcllyzPO9tW2v+xcuDh9lXJfmhX4wpM=;
 b=m8C/0fo/6T32I57SHisIesANMqLecNELmCUziiQGbQfGjTtYvTI9zpHcVl8YJq1R1j
 h8hNVaGQp8Kk6MqNHUMwDl+GiVWenpqvG00bB5nkuG+J4CmL36wc7/Oe0eQ9QepZcbOu
 FxK6T00Wr2ZzZXVPeqzNdihM/COvb9nHV6nybrSHRmGqLvNpnVuE7Ky8VCQEhuN+TWLN
 +hkLhMTsMmO+S+/T2ju83UjJce9VSw4Do4dh0vPna4CbRxk1bQsFNOF2iUaPr3v7/4Ve
 YLMf6bQVNcdhBc2wYWgVGEms63Vrr41Ana6uwDSqhv6XNet9uZQQByKCE3Q26QpYj9Dk
 15cw==
X-Gm-Message-State: AOAM533nuj8eK5OC3uOnN/OyWLK/f7RHEJtogA1M0qNGd1o83GKv4yeg
 U6uG/os4uQ33n/2QwF98/W+adOH0FeCXCVwH5T8b8w==
X-Google-Smtp-Source: ABdhPJxux7+upU3PjgLsBl4Bp9EglwkuntvBclKRfPrKEh0eH2UrhcoTX7EKC/yMVa/XNH2i8eefouAkVav6EyslkVM=
X-Received: by 2002:a81:4ed5:0:b0:2dc:e57:e5f2 with SMTP id
 c204-20020a814ed5000000b002dc0e57e5f2mr19128109ywb.199.1647268352833; Mon, 14
 Mar 2022 07:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
In-Reply-To: <Yi9LlP+x2swdsrbE@kroah.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 14 Mar 2022 20:02:21 +0530
Message-ID: <CA+G9fYuwyUPMBRuBL10Z0r1MRt0sZ-MqvC6ySHBtpqdSp8UcDQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvmarm@lists.cs.columbia.edu, f.fainelli@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, pavel@denx.de, shuah@kernel.org,
 slade@sladewatkins.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Jon Hunter <jonathanh@nvidia.com>, lkft-triage@lists.linaro.org,
 patches@kernelci.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, akpm@linux-foundation.org,
 torvalds@linux-foundation.org, sudipm.mukherjee@gmail.com, linux@roeck-us.net
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

PiA+ID4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6Cj4gPiA+ICAgICBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxlL2xpbnV4LXN0YWJs
ZS1yYy5naXQgbGludXgtNC4xOS55Cj4gPiA+IGFuZCB0aGUgZGlmZnN0YXQgY2FuIGJlIGZvdW5k
IGJlbG93Lgo+ID4gPgo+ID4gPiB0aGFua3MsCj4gPiA+Cj4gPiA+IGdyZWcgay1oCj4gPiA+Cj4g
PiA+IC0tLS0tLS0tLS0tLS0KPiA+ID4gUHNldWRvLVNob3J0bG9nIG9mIGNvbW1pdHM6Cj4gPgo+
ID4gLi4uCj4gPgo+ID4gPiBKYW1lcyBNb3JzZSA8amFtZXMubW9yc2VAYXJtLmNvbT4KPiA+ID4g
ICAgICBLVk06IGFybTY0OiBSZXNldCBQTUNfRUwwIHRvIGF2b2lkIGEgcGFuaWMoKSBvbiBzeXN0
ZW1zIHdpdGggbm8gUE1VCj4gPgo+ID4KPiA+IFRoZSBhYm92ZSBpcyBjYXVzaW5nIHRoZSBmb2xs
b3dpbmcgYnVpbGQgZXJyb3IgZm9yIEFSTTY0IC4uLgo+ID4KPiA+IGFyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmM6IEluIGZ1bmN0aW9uIOKAmHJlc2V0X3BtY3LigJk6Cj4gPiBhcmNoL2FybTY0L2t2
bS9zeXNfcmVncy5jOjYyNDozOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rp
b24g4oCYdmNwdV9zeXNfcmVn4oCZIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0
aW9uXQo+ID4gICAgdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ1JfRUwwKSA9IDA7Cj4gPiAgICBefn5+
fn5+fn5+fn4KPiA+IGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmM6NjI0OjMyOiBlcnJvcjogbHZh
bHVlIHJlcXVpcmVkIGFzIGxlZnQgb3BlcmFuZCBvZiBhc3NpZ25tZW50Cj4gPiAgICB2Y3B1X3N5
c19yZWcodmNwdSwgUE1DUl9FTDApID0gMDsKPiA+Cj4KPiBJcyB0aGlzIGFsc28gYnJva2VuIGlu
IExpbnVzJ3MgdHJlZT8KCm5vcGUuCkl0IGlzIGFsc28gb25seSBvbiA0LjE5LgoKLS0KTGluYXJv
IExLRlQKaHR0cHM6Ly9sa2Z0LmxpbmFyby5vcmcKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
