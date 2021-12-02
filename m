Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E408DC43219
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 11:54:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C97D4B15B;
	Thu,  2 Dec 2021 06:54:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KLFIdwy65XIy; Thu,  2 Dec 2021 06:54:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC094B1E6;
	Thu,  2 Dec 2021 06:54:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAFDD4B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:54:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qAxozspIjZwi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 06:53:58 -0500 (EST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48CBB4B14D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:53:58 -0500 (EST)
Received: by mail-wm1-f53.google.com with SMTP id
 d72-20020a1c1d4b000000b00331140f3dc8so3373383wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 03:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=O1VjI2U7XfRKbg+ZSN6i6QVFf+SzgfTpuCobVzeKOYA=;
 b=AZ6RZnRldc+wfjD7JyNw6gVSzMplldw/x0sXKFmvOTWX3o5QfKU8dEdAOs8ovGCvAx
 +3t9SQWgsaXbcjijZx2L7h5bLu4pHt+EAKzxd5DT0RdYn7ZMMDkua1FFgPNpZWYHbi/I
 olqpTc7K1bIvjBJykg4RE7jTYaDxNhyAKojMUI0/sy3mugJ1JAaqO0fM3hrU6VRzy7v0
 r7cpZNC441WuUmlMskvHTEofZiDvVZ/YwjgWAgWZx/M1pB+3pkcZe+C4uom+LkCKlpR/
 mavFXZYdL+q8DSR3GMu6gwg7b2pqveN89XtUhM4euL78f5BFMuXuoELzSnoQ0xT7dR99
 EyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=O1VjI2U7XfRKbg+ZSN6i6QVFf+SzgfTpuCobVzeKOYA=;
 b=Qj+zl/3/UBcV1Tvqaw7ihKeFxZ8GxbxhNlYLZmLC+XJjn1uesOpji+X1H8Xc8YBanT
 kYC1UGxUUqzKze5F+EoaeylTURvBpTIIdJypu0x4Ifiy2YKJ4X2W/Imjpi43M74CoWoD
 Xuk9DulY0okohxfhp083oSKYB1QfYURGta2+5FPyLM5+s7vC7rBMQSaJwSeBMCMIn+bH
 5qVc0FdAmeEyJfsodS39sPcZ083WRDiLxY2xETR/EFivPfWMzVFs6m4PxMYj+c43VFzO
 NPcc41GEe9co59BnEnupu3LrUSkeSzAjjyHUj5gTcHXfVK7Fcg4EaFi4q8ixpiOujuOe
 Q2ow==
X-Gm-Message-State: AOAM532TczcNRqBC0QcW9ZBmFCI1Sul+fxk+c/4KoDOO337W4li/mY7q
 VODbdOtz9DrANZDdilKJ4Kr3pQ==
X-Google-Smtp-Source: ABdhPJzB8IQIjbi+vExxEGobek/s0HfYc8nfaQmzYUgGnjdRCz1Mc2+bXvqXWGaBGzOoxzN3h7vz3g==
X-Received: by 2002:a1c:4d15:: with SMTP id o21mr5670343wmh.171.1638446037479; 
 Thu, 02 Dec 2021 03:53:57 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id f15sm2448078wmg.30.2021.12.02.03.53.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 9C93D1FF99;
 Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v9 2/9] arm/flat.lds: don't drop debug during
 link
Date: Thu,  2 Dec 2021 11:53:45 +0000
Message-Id: <20211202115352.951548-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, christoffer.dall@arm.com,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SXQgaXMgdXNlZnVsIHRvIGtlZXAgdGhlIGRlYnVnIGluIHRoZSAuZWxmIGZpbGUgc28gd2UgY2Fu
IGRlYnVnIGFuZCBpdApkb2Vzbid0IGdldCBjb3BpZWQgYWNyb3NzIHRvIHRoZSBmaW5hbCAuZmxh
dCBmaWxlLiBPZiBjb3Vyc2Ugd2Ugc3RpbGwKbmVlZCB0byBlbnN1cmUgd2UgYXBwbHkgdGhlIG9m
ZnNldCB3aGVuIHdlIGxvYWQgdGhlIHN5bWJvbHMgYmFzZWQgb24Kd2hlcmUgUUVNVSBkZWNpZGVk
IHRvIGxvYWQgdGhlIGtlcm5lbC4KCiAgKGdkYikgc3ltYm9sLWZpbGUgLi9idWlsZHMvYXJtNjQv
YXJtL3RsYmZsdXNoLWRhdGEuZWxmIC1vIDB4NDAwODAwMDAKClNpZ25lZC1vZmYtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KTWVzc2FnZS1JZDogPDIwMjExMTE4MTg0
NjUwLjY2MTU3NS0zLWFsZXguYmVubmVlQGxpbmFyby5vcmc+Ci0tLQogYXJtL2ZsYXQubGRzIHwg
MSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2FybS9mbGF0
LmxkcyBiL2FybS9mbGF0LmxkcwppbmRleCA2ZmI0NTllZi4uNDdmY2I2NDkgMTAwNjQ0Ci0tLSBh
L2FybS9mbGF0LmxkcworKysgYi9hcm0vZmxhdC5sZHMKQEAgLTYyLDcgKzYyLDYgQEAgU0VDVElP
TlMKICAgICAvRElTQ0FSRC8gOiB7CiAgICAgICAgICooLm5vdGUqKQogICAgICAgICAqKC5pbnRl
cnApCi0gICAgICAgICooLmRlYnVnKikKICAgICAgICAgKiguY29tbWVudCkKICAgICAgICAgKigu
ZHluYW1pYykKICAgICB9Ci0tIAoyLjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
