Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0A2C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 16:09:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43D432076B
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 16:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XwrPkUNK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43D432076B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05454B1F6;
	Tue, 14 Apr 2020 12:09:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lOsXTV-ZecoX; Tue, 14 Apr 2020 12:09:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D3E4B1FA;
	Tue, 14 Apr 2020 12:09:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9135A4B15B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:57:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J+sMksC6bzP8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 11:57:08 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 184D74B1C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:57:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586879827;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LtET4y1erldy/ABcJ/1Ge/mDl44RsauO4InLRypykLQ=;
 b=XwrPkUNKGxfcj8MpzzodKwoCO/nYlwvP3KomKIdI2OYOhrQo8cwi3KV8QH2wbIVyhUhKmj
 D9yEWDansbnqpSbRglxpyiGD+iepesHfBEJ1Udom8du80cxf00l7Az5l5Gu+YD4i5G82If
 74WzD8VAuZ4Ey0D/3OFqjSVZR9hO0wM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-he1JbCz-PzSVbRjqtanVdQ-1; Tue, 14 Apr 2020 11:57:06 -0400
X-MC-Unique: he1JbCz-PzSVbRjqtanVdQ-1
Received: by mail-wm1-f69.google.com with SMTP id f17so3982228wmm.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 08:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+YYLNoHPS0R9msE++qaePEk7EKWnckmMQYzoCYqpJRk=;
 b=uK3/ScFYj5GE5DupmqkCp2KAdSqoYa+V98FTK8CgoZU+hGzKGIDpz5IrLHr3N022mY
 LdpB7TfLTR04bZN7v0TIwvimxdiLnuI8JHQbIDcJYF0dkhLTSO1lS7q+Gh2jh/BKBJdw
 eGYrDZb1PWtbZ07xrX2/Wc+hIHn4tyj80MaIzVaKF3L4hQaBWOQU5UY/BpZiobj0NZNc
 apmhLnGOFtA3qvpXKWeuMNMlUS4UxIyaKZ1f5bxfSrcQsFJbRlWf6lj+eHZXy1ThVj8P
 PjrJYo2htutfUQ1J9C8eHQgEJmQBwRjkiTZ46ypitMgqvDgbQdIi93UW5EaOmo+/WxML
 JxDg==
X-Gm-Message-State: AGi0PuadJxoC8ZcWVc8MwTr9OvkEDPFwCffd0r9Jwy/kYAjSNbcnFoWu
 DvYKzuQ1xaMkNzOymF8dcVzln6O2Rwgmcw5NMESOT7g+caz3316amBNysDeaeBdSwzullkxosmI
 jTd7trzyXyL4vfuo/SHJW4UEQ
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502939wmb.93.1586879825146;
 Tue, 14 Apr 2020 08:57:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypK43hPUptF5L9yvQziVzJGJV/VyMhS23tlGH7dzBh06iijjr98+S1d6K1K1pTXXFtXi18cgZQ==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502914wmb.93.1586879824909;
 Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.210])
 by smtp.gmail.com with ESMTPSA id j10sm16390309wmi.18.2020.04.14.08.57.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
 <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
 <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <a5e9246e-2bf3-204e-b79b-0ed4c40fcc5d@redhat.com>
Date: Tue, 14 Apr 2020 17:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 14 Apr 2020 12:08:58 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiA0LzE0LzIwIDEwOjE4IEFNLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDEzLzA0LzIw
IDIzOjM0LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToKPj4+ICsjZGVmaW5lIFZNX1NU
QVQoeCwgLi4uKSBvZmZzZXRvZihzdHJ1Y3Qga3ZtLCBzdGF0LngpLCBLVk1fU1RBVF9WTSwgIyMg
X19WQV9BUkdTX18KPj4+ICsjZGVmaW5lIFZDUFVfU1RBVCh4LCAuLi4pIG9mZnNldG9mKHN0cnVj
dCBrdm1fdmNwdSwgc3RhdC54KSwgS1ZNX1NUQVRfVkNQVSwgIyMgX19WQV9BUkdTX18KPj4gSSBm
aW5kIHRoaXMgbWFjcm8gZXhwYW5kaW5nIGludG8gbXVsdGlwbGUgZmllbGRzIG9kZC4uLiBNYXli
ZSBhIG1hdHRlcgo+PiBvZiB0YXN0ZS4gU3VnZ2dlc3Rpb24sIGhhdmUgdGhlIG1hY3JvIGRlZmlu
ZSB0aGUgZnVsbCBzdHJ1Y3R1cmUsIGFzIGluCj4+IHRoZSBhcm02NCBhcmNoOgo+Pgo+PiAjZGVm
aW5lIFZNX1NUQVQobiwgeCwgLi4uKSB7IG4sIG9mZnNldG9mKHN0cnVjdCBrdm0sIHN0YXQueCks
Cj4+IEtWTV9TVEFUX1ZNLCAjIyBfX1ZBX0FSR1NfXyB9Cj4+Cj4+IERpdHRvIGZvciBWQ1BVX1NU
QVQoKS4KPj4KSGkgUGhpbGlwcGUgYW5kIFBhb2xvLAo+IAo+IFllcywgdGhhdCdzIGEgZ29vZCBp
ZGVhLiAgRW1hbnVlbGUsIGNhbiB5b3Ugc3dpdGNoIGl0IHRvIHRoaXMgZm9ybWF0PwoKU3VyZSwg
SSBqdXN0IHN1Ym1pdHRlZCB0aGUgdjIgdmVyc2lvbi4KClRoYW5rcywKCkVtYW51ZWxlCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
