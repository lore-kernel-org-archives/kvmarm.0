Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82ADBC35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B8462082E
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhGNmAko"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B8462082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E744A418;
	Wed,  5 Feb 2020 17:48:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PQtC5hZ1kp+E; Wed,  5 Feb 2020 17:48:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4965B4A535;
	Wed,  5 Feb 2020 17:48:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6AA4A535
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:48:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SiRazNznqLUy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 17:48:17 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4D94A418
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 17:48:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580942897;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UTyFakDDuLK102/yDNVxyRkfYzuB7bVGBHMGZVGioTU=;
 b=QhGNmAkoVv5L6Mofr20q2J0HPegnKPRWC3/2vN0GKA9fNAzWTzHCGPOMQUB4h5UM2upAmv
 66RTaX+qHnToeApVDczr6ORkZ0HFR6omn+agEg/ljbuJ5RD/6+fxIxfMlNttwhKW6LrJ4I
 oF2a8xLdty9hOifbDFFlnugYogLSThk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115--BVTSOUtOquHSkji8OlyYA-1; Wed, 05 Feb 2020 17:48:13 -0500
Received: by mail-qk1-f200.google.com with SMTP id q135so2315024qke.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 14:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=2cHEFoE8jbw7EqsKmYikm9pxnEO2ox+NzDcqYlTv6MQ=;
 b=hlkQlbQdr32bo69HHdnJ2AgXEV21Waabij9yjYH79E28aB8f1hPkogRorRYZBWhtQO
 rwASt0KhuVwxFsYYaTek06u0J7O8OSSrqfJIvqSSAtDDZQtXp5gfjzv2K3Jcc5jbJ5sM
 aUFaA6lHd39cTVZL+noMzGDlxC/vOwKRkgxkUvwsQ03ByuQwanelMNO+cOPApOGAXTjl
 IRXE1U7bTQVnUggipOFHK8n4CC7UXUeMF4dMNTBPj+uqQTILOkTS43Lo62r/zWZMrJdZ
 Y0Oi+WqvGF/yvTinkoW65mliRXXaa1RCRIn6LZnXelk7ZowevYgRuLTbiJZtadHVgE0b
 rSnQ==
X-Gm-Message-State: APjAAAUNhrNSckRUlW68EWwG0ZhatB9uvU+8mbosegDuVtQeAEPoOtPA
 Or7KFDFg7USWoNOHNtHUfV+VsRGXA8ky0BqLEPc8/5s2R0lgpy+LpIw9PuDvZShnFSPnyFeLiWU
 Bdky730fJA7ZIBPsFC94Fl/iP
X-Received: by 2002:ac8:718e:: with SMTP id w14mr82103qto.266.1580942892811;
 Wed, 05 Feb 2020 14:48:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzidgvMzifyXKMl5xyBUEvf76nUThQJ4Vf+I9H3f+5mpj/6PKciWyQRPVlUWOeD9yt6R/onsg==
X-Received: by 2002:ac8:718e:: with SMTP id w14mr82077qto.266.1580942892562;
 Wed, 05 Feb 2020 14:48:12 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id s67sm562392qke.1.2020.02.05.14.48.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 14:48:11 -0800 (PST)
Date: Wed, 5 Feb 2020 17:48:09 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 08/19] KVM: Refactor error handling for setting memory
 region
Message-ID: <20200205224809.GI387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-9-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-9-sean.j.christopherson@intel.com>
X-MC-Unique: -BVTSOUtOquHSkji8OlyYA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

T24gVHVlLCBKYW4gMjEsIDIwMjAgYXQgMDI6MzE6NDZQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToKPiBSZXBsYWNlIGEgYmlnIHBpbGUgbycgZ290b3Mgd2l0aCByZXR1cm5zIHRv
IG1ha2UgaXQgbW9yZSBvYnZpb3VzIHdoYXQKPiBlcnJvciBjb2RlIGlzIGJlaW5nIHJldHVybmVk
LCBhbmQgdG8gcHJlcGFyZSBmb3IgcmVmYWN0b3JpbmcgdGhlCj4gZnVuY3Rpb25hbCwgaS5lLiBw
b3N0LWNoZWNrcywgcG9ydGlvbiBvZiBfX2t2bV9zZXRfbWVtb3J5X3JlZ2lvbigpLgo+IAo+IFJl
dmlld2VkLWJ5OiBKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+Cj4gUmV2aWV3
ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxmNGJ1Z0BhbXNhdC5vcmc+Cj4gU2lnbmVk
LW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVs
LmNvbT4KClJldmlld2VkLWJ5OiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+CgotLSAKUGV0
ZXIgWHUKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
