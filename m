Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF3AC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:22:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF53D61502
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF53D61502
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37FE24B32B;
	Tue,  5 Oct 2021 11:22:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fA31+tuI0hHQ; Tue,  5 Oct 2021 11:22:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2BB4B30F;
	Tue,  5 Oct 2021 11:22:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590A34B305
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:22:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Y2a+BSU-efa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 11:22:44 -0400 (EDT)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35AEF4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:22:44 -0400 (EDT)
Received: by mail-pg1-f182.google.com with SMTP id h3so9453094pgb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 08:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=jsoEJt9R8crAH2RcsfBnQLCdcmXo4iVFPCHH8skN9hQ=;
 b=Ed27JI5WdcMBjzCmHglgYbPkFapHRW8VivzST0erYb/L/PV6Fx0rpTBNDt1223jRVb
 eQ5IVgSRDi5VCqGDiJM5A7rbcPMvwg6w1jg0wDhDNxogy7g8tXHb5gAQu3MkQZ4aTk9Q
 D+35shvAdiTeBDH9W72MNR7F3tUnMUT8t+zTm8lCHdonVdqfrCyFpDQ97vP6AwGRNn/X
 GOqBrTVYIjZiBhdOV7etEqYr4+lx5qlCy7z4mzvugVDQwWWAnXWWM9Dac9u4kMeqF4o0
 q66/1KN+gVVuBQ71H+9jz7Qi8kNlcIq5g+ueK+T83d6rxeradLUvtNWie9PUJyUcAjyk
 VesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=jsoEJt9R8crAH2RcsfBnQLCdcmXo4iVFPCHH8skN9hQ=;
 b=VbbMKi2HkSc7rRKO7CRFBvavkkXbNqUubQn0+U/y3Gtf87WI57j2tk6BXrrFbB1/WT
 m+eWO3GefoqQUV8LGZOYUi8kxpNrE7LhkQ8Z9Y83sTxFykXKNdN9SGJyVwSSqTJJxwnn
 qu4jL54jzBkym1k/ABGTqVV2HvNNDCLlNlYrQgVw5MmQpwA2k9EEbxSGvRgfMbivm6+g
 b8792ad7/dO/BNXYMSb8iOlykWzwTXiHsv3aq/cu37ptwG/cDh0h/xZFB6dmBPwcSdk6
 tNbYN9/r7SZLJePGXBZ2eJjMxFuQ4P0nlm8ZXRD9VC4c8jaJUnfcLDEFKa1+IcNv1aAM
 19fQ==
X-Gm-Message-State: AOAM531zfatvCCVzQ81/pUGYhWygHRX+78+jd7sdUZssr/lsXdzl45b+
 Vn80ShRI6FKZCryUE0ilxsUCrA==
X-Google-Smtp-Source: ABdhPJyd+BrY951cMRvWU+Hdnw02yUD1081dLTCog2uFgukEdDRDWflW+t6MGsO3nWUcqCgRuybMcw==
X-Received: by 2002:a62:b50d:0:b0:44b:b81f:a956 with SMTP id
 y13-20020a62b50d000000b0044bb81fa956mr30655368pfe.27.1633447363159; 
 Tue, 05 Oct 2021 08:22:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id z2sm6907837pfe.210.2021.10.05.08.22.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 08:22:42 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:22:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <YVxtvx3IJ5g1SG+x@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-8-oupton@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

T24gVGh1LCBTZXAgMTYsIDIwMjEsIE9saXZlciBVcHRvbiB3cm90ZToKPiArc3RhdGljIGludCBr
dm1fYXJjaF90c2NfZ2V0X2F0dHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICsJCQkJIHN0cnVj
dCBrdm1fZGV2aWNlX2F0dHIgKmF0dHIpCj4gK3sKPiArCXU2NCBfX3VzZXIgKnVhZGRyID0gKHU2
NCBfX3VzZXIgKilhdHRyLT5hZGRyOwoKLi4uCgo+ICtzdGF0aWMgaW50IGt2bV9hcmNoX3RzY19z
ZXRfYXR0cihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gKwkJCQkgc3RydWN0IGt2bV9kZXZpY2Vf
YXR0ciAqYXR0cikKPiArewo+ICsJdTY0IF9fdXNlciAqdWFkZHIgPSAodTY0IF9fdXNlciAqKWF0
dHItPmFkZHI7CgpUaGVzZSBjYXN0cyBicmVhayAzMi1iaXQgYnVpbGRzIGJlY2F1c2Ugb2YgdHJ1
bmNhdGluZyBhdHRyLT5hZGRyIGZyb20gNjQtYml0IGludAp0byBhIDMyLWJpdCBwb2ludGVyLiAg
VGhlIGFkZHJlc3Mgc2hvdWxkIGFsc28gYmUgY2hlY2tlZCB0byB2ZXJpZnkgYml0cyA2MzozMiBh
cmUKbm90IHNldCBvbiAzMi1iaXQga2VybmVscy4KCmFyY2gveDg2L2t2bS94ODYuYzogSW4gZnVu
Y3Rpb24g4oCYa3ZtX2FyY2hfdHNjX2dldF9hdHRy4oCZOgphcmNoL3g4Ni9rdm0veDg2LmM6NDk0
NzoyMjogZXJyb3I6IGNhc3QgdG8gcG9pbnRlciBmcm9tIGludGVnZXIgb2YgZGlmZmVyZW50IHNp
emUgWy1XZXJyb3I9aW50LXRvLXBvaW50ZXItY2FzdF0KIDQ5NDcgfCAgdTY0IF9fdXNlciAqdWFk
ZHIgPSAodTY0IF9fdXNlciAqKWF0dHItPmFkZHI7CiAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgXgphcmNoL3g4Ni9rdm0veDg2LmM6IEluIGZ1bmN0aW9uIOKAmGt2bV9hcmNoX3RzY19zZXRf
YXR0cuKAmToKYXJjaC94ODYva3ZtL3g4Ni5jOjQ5Njc6MjI6IGVycm9yOiBjYXN0IHRvIHBvaW50
ZXIgZnJvbSBpbnRlZ2VyIG9mIGRpZmZlcmVudCBzaXplIFstV2Vycm9yPWludC10by1wb2ludGVy
LWNhc3RdCiA0OTY3IHwgIHU2NCBfX3VzZXIgKnVhZGRyID0gKHU2NCBfX3VzZXIgKilhdHRyLT5h
ZGRyOwogICAgICB8ICAgICAgICAgICAgICAgICAgICAgIF4KCgpOb3Qgc3VyZSBpZiB0aGVyZSdz
IGEgbW9yZSBlbGVnYW50IGFwcHJvYWNoIHRoYW4gY2FzdHMgZ2Fsb3JlPwoKZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYwppbmRleCA4ZTVlNDYyZmZk
NjUuLjM5MzBlNWRjZGYwZSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jCisrKyBiL2Fy
Y2gveDg2L2t2bS94ODYuYwpAQCAtNDk0NCw5ICs0OTQ0LDEyIEBAIHN0YXRpYyBpbnQga3ZtX2Fy
Y2hfdHNjX2hhc19hdHRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIHN0YXRpYyBpbnQga3ZtX2Fy
Y2hfdHNjX2dldF9hdHRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IGt2bV9kZXZpY2VfYXR0ciAqYXR0cikKIHsKLSAgICAgICB1
NjQgX191c2VyICp1YWRkciA9ICh1NjQgX191c2VyICopYXR0ci0+YWRkcjsKKyAgICAgICB1NjQg
X191c2VyICp1YWRkciA9ICh1NjQgX191c2VyICopKHVuc2lnbmVkIGxvbmcpYXR0ci0+YWRkcjsK
ICAgICAgICBpbnQgcjsKCisgICAgICAgaWYgKCh1NjQpKHVuc2lnbmVkIGxvbmcpdWFkZHIgIT0g
YXR0ci0+YWRkcikKKyAgICAgICAgICAgICAgIHJldHVybiAtRUZBVUxUOworCiAgICAgICAgc3dp
dGNoIChhdHRyLT5hdHRyKSB7CiAgICAgICAgY2FzZSBLVk1fVkNQVV9UU0NfT0ZGU0VUOgogICAg
ICAgICAgICAgICAgciA9IC1FRkFVTFQ7CkBAIC00OTY0LDEwICs0OTY3LDEzIEBAIHN0YXRpYyBp
bnQga3ZtX2FyY2hfdHNjX2dldF9hdHRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIHN0YXRpYyBp
bnQga3ZtX2FyY2hfdHNjX3NldF9hdHRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGt2bV9kZXZpY2VfYXR0ciAqYXR0cikKIHsK
LSAgICAgICB1NjQgX191c2VyICp1YWRkciA9ICh1NjQgX191c2VyICopYXR0ci0+YWRkcjsKKyAg
ICAgICB1NjQgX191c2VyICp1YWRkciA9ICh1NjQgX191c2VyICopKHVuc2lnbmVkIGxvbmcpYXR0
ci0+YWRkcjsKICAgICAgICBzdHJ1Y3Qga3ZtICprdm0gPSB2Y3B1LT5rdm07CiAgICAgICAgaW50
IHI7CgorICAgICAgIGlmICgodTY0KSh1bnNpZ25lZCBsb25nKXVhZGRyICE9IGF0dHItPmFkZHIp
CisgICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsKKwogICAgICAgIHN3aXRjaCAoYXR0ci0+
YXR0cikgewogICAgICAgIGNhc2UgS1ZNX1ZDUFVfVFNDX09GRlNFVDogewogICAgICAgICAgICAg
ICAgdTY0IG9mZnNldCwgdHNjLCBuczsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
