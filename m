Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70269C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21F1A61B1E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 21F1A61B1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6364B1E1;
	Thu, 18 Nov 2021 13:47:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5y3rsr30lPss; Thu, 18 Nov 2021 13:47:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC914B22B;
	Thu, 18 Nov 2021 13:47:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B18A64B1E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYnzMn5TfNZ0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:46:58 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 877894B21E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:58 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id
 p3-20020a05600c1d8300b003334fab53afso8450900wms.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=eaPUXaq41WZH/h6GYRFaezaVsEA4ttJDyJAW7JSISJY=;
 b=F2gHMH6vwR4xvqpoXWpgXJXoDksN1UxSEkEmbqmlD8hyupOtNFO3mGg1RFg2TX62I0
 xaVKX0aL2NMGzFQ7eMYjleeolRXafF/TqwYxwneEasRcGVHXl9epK3WPRzqcTmi+iari
 8D1slSEtOH3Kcb+9lMZCC5DUr/4MEXsoYBE5MKGETfA15XQ6FsHrOCcgkCH8hu/Ar5LW
 w+aYUP1y+h/3dKHWBAedUL1pTKEzA2KvVoU2gHvciE3OMO5GFXa9/4ysbEzpyvaNQaO/
 BibROcRlDz9v5WAQZTmIZvB17dBLXL1BiGJytnG6W9zHQHW0EGbhak1/43tvnoirJFAe
 wCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=eaPUXaq41WZH/h6GYRFaezaVsEA4ttJDyJAW7JSISJY=;
 b=3zmZsjq2n01HHiQ4yszch/Avb0UfY9WqdCIMc4vJAAJPK2OMgMgwgUW0fmaWzizWnZ
 z8yhOIp8jLeqXf9lMyuaTBAcmvMAUlkvgPhwRQv7pUjHkWfP5CrB1jSPybNF86wyEB2r
 gc3BxYMTwHnErOILjb8zRQuElTSDPvD8osT44+ywO9042HHWSrr4xG1rV9Hy+D99pMEf
 6GSQPuncOADpk/l020m21eYotfFH6JERH8K6ifkJDCdY9hikC423Dc6r15ess9W0owPj
 kjnBf2nsn4fRfwkX9uNLORNK4YbuBRgFGLBVjskMdGrwMKQQW7HpeyirHMZfFGGA31d6
 /j4w==
X-Gm-Message-State: AOAM531STt2TTWrpf+AlpNVsnBq43DuBAXZe44rEZ8MLbjCiRV7DppSw
 zfKc5fW2WjQKuDWoVb1xtOvYyw==
X-Google-Smtp-Source: ABdhPJxi0gHTPCkCLhwz4sZpESe0ZsiFVHaJxtTlU8ot0566wwXQutX6kiYchOOZ+lORo2U9U57Iog==
X-Received: by 2002:a1c:9a4f:: with SMTP id c76mr12329695wme.162.1637261217715; 
 Thu, 18 Nov 2021 10:46:57 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id q26sm654555wrc.39.2021.11.18.10.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 583341FF9B;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config option for
 alt test set
Date: Thu, 18 Nov 2021 18:46:44 +0000
Message-Id: <20211118184650.661575-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, qemu-arm@nongnu.org, idan.horowitz@gmail.com,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

VGhlIHVwY29taW5nIE1UVENHIHRlc3RzIGRvbid0IG5lZWQgdG8gYmUgcnVuIGZvciBub3JtYWwg
S1ZNIHVuaXQKdGVzdHMgc28gbGV0cyBhZGQgdGhlIGZhY2lsaXR5IHRvIGhhdmUgYSBjdXN0b20g
c2V0IG9mIHRlc3RzLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBs
aW5hcm8ub3JnPgotLS0KIHJ1bl90ZXN0cy5zaCB8IDExICsrKysrKysrLS0tCiAxIGZpbGUgY2hh
bmdlZCwgOCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3J1bl90
ZXN0cy5zaCBiL3J1bl90ZXN0cy5zaAppbmRleCA5ZjIzM2M1Li5iMTA4OGQyIDEwMDc1NQotLS0g
YS9ydW5fdGVzdHMuc2gKKysrIGIvcnVuX3Rlc3RzLnNoCkBAIC0xNSw3ICsxNSw3IEBAIGZ1bmN0
aW9uIHVzYWdlKCkKIHsKIGNhdCA8PEVPRgogCi1Vc2FnZTogJDAgWy1oXSBbLXZdIFstYV0gWy1n
IGdyb3VwXSBbLWogTlVNLVRBU0tTXSBbLXRdCitVc2FnZTogJDAgWy1oXSBbLXZdIFstYV0gWy1n
IGdyb3VwXSBbLWogTlVNLVRBU0tTXSBbLXRdIFstYyBDT05GSUddCiAKICAgICAtaCwgLS1oZWxw
ICAgICAgT3V0cHV0IHRoaXMgaGVscCB0ZXh0CiAgICAgLXYsIC0tdmVyYm9zZSAgIEVuYWJsZXMg
dmVyYm9zZSBtb2RlCkBAIC0yNCw2ICsyNCw3IEBAIFVzYWdlOiAkMCBbLWhdIFstdl0gWy1hXSBb
LWcgZ3JvdXBdIFstaiBOVU0tVEFTS1NdIFstdF0KICAgICAtZywgLS1ncm91cCAgICAgT25seSBl
eGVjdXRlIHRlc3RzIGluIHRoZSBnaXZlbiBncm91cAogICAgIC1qLCAtLXBhcmFsbGVsICBFeGVj
dXRlIHRlc3RzIGluIHBhcmFsbGVsCiAgICAgLXQsIC0tdGFwMTMgICAgIE91dHB1dCB0ZXN0IHJl
c3VsdHMgaW4gVEFQIGZvcm1hdAorICAgIC1jLCAtLWNvbmZpZyAgICBPdmVycmlkZSBkZWZhdWx0
IHVuaXR0ZXN0cy5jZmcKIAogU2V0IHRoZSBlbnZpcm9ubWVudCB2YXJpYWJsZSBRRU1VPS9wYXRo
L3RvL3FlbXUtc3lzdGVtLUFSQ0ggdG8KIHNwZWNpZnkgdGhlIGFwcHJvcHJpYXRlIHFlbXUgYmlu
YXJ5IGZvciBBUkNILXJ1bi4KQEAgLTQyLDcgKzQzLDcgQEAgaWYgWyAkPyAtbmUgNCBdOyB0aGVu
CiBmaQogCiBvbmx5X3Rlc3RzPSIiCi1hcmdzPSQoZ2V0b3B0IC11IC1vIGFnOmh0ajp2IC1sIGFs
bCxncm91cDosaGVscCx0YXAxMyxwYXJhbGxlbDosdmVyYm9zZSAtLSAkKikKK2FyZ3M9JChnZXRv
cHQgLXUgLW8gYWc6aHRqOnZjOiAtbCBhbGwsZ3JvdXA6LGhlbHAsdGFwMTMscGFyYWxsZWw6LHZl
cmJvc2UsY29uZmlnOiAtLSAkKikKIFsgJD8gLW5lIDAgXSAmJiBleGl0IDI7CiBzZXQgLS0gJGFy
Z3M7CiB3aGlsZSBbICQjIC1ndCAwIF07IGRvCkBAIC03Myw2ICs3NCwxMCBAQCB3aGlsZSBbICQj
IC1ndCAwIF07IGRvCiAgICAgICAgIC10IHwgLS10YXAxMykKICAgICAgICAgICAgIHRhcF9vdXRw
dXQ9InllcyIKICAgICAgICAgICAgIDs7CisgICAgICAgIC1jIHwgLS1jb25maWcpCisgICAgICAg
ICAgICBzaGlmdAorICAgICAgICAgICAgY29uZmlnPSQxCisgICAgICAgICAgICA7OwogICAgICAg
ICAtLSkKICAgICAgICAgICAgIDs7CiAgICAgICAgICopCkBAIC0xNTIsNyArMTU3LDcgQEAgZnVu
Y3Rpb24gcnVuX3Rhc2soKQogCiA6ICR7dW5pdHRlc3RfbG9nX2Rpcjo9bG9nc30KIDogJHt1bml0
dGVzdF9ydW5fcXVldWVzOj0xfQotY29uZmlnPSRURVNUX0RJUi91bml0dGVzdHMuY2ZnCis6ICR7
Y29uZmlnOj0kVEVTVF9ESVIvdW5pdHRlc3RzLmNmZ30KIAogcm0gLXJmICR1bml0dGVzdF9sb2df
ZGlyLm9sZAogWyAtZCAkdW5pdHRlc3RfbG9nX2RpciBdICYmIG12ICR1bml0dGVzdF9sb2dfZGly
ICR1bml0dGVzdF9sb2dfZGlyLm9sZAotLSAKMi4zMC4yCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
