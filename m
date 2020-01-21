Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617ACC3F68F
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD04524653
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 14:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePuEbXF8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD04524653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 604684AFC4;
	Tue, 21 Jan 2020 09:41:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VBoMvHhAG1pj; Tue, 21 Jan 2020 09:40:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D744AFE4;
	Tue, 21 Jan 2020 09:40:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 558514AFC4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:40:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VkXpGzdfmmQe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 09:40:50 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BE54AF8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 09:40:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579617650;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
 b=ePuEbXF8KJaFFrp++v10U6+wn27XXseHGhCPjmNhcJWXh6llUC84JzkVlbinp5gAhAHy3s
 6pzlE8f5EdkzF0lhQTekCN45TF3viQPF1lLONJc4M2Ba0c0U3LUfY4wL4RzvZ1EvWhu/iR
 H5OPE7Y2WAjjWjBOXbHvXDGWemZ4ACw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-_Zf8drMGMU-IKtS0u_ZdZw-1; Tue, 21 Jan 2020 09:40:46 -0500
Received: by mail-wr1-f72.google.com with SMTP id o6so1392355wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
 b=VcyZ0Dc/rVqyKwvp5Dx7Dyvd5klSFrAVXejwYGi79SmH8Hg75g1G3KkixyCT92beKw
 gltGYcsfputvxGP9NL5RU8eCbKdQW6CH0RVq06zb6AgzNGfGxBNUayABO10fHVbhc5W+
 n28nR0Gx4ZZwculhPUnfOxqrfGKedfR07U5M59DfCQ90xy8kzLPUKdDRFCyHkJ1JlhAM
 Jrup2W9/yC0c3D4Prru4/sM/vGPUiDZIM0q3IVvKVAp6FkXW1fqoL/OEQoyr2127I0BG
 rbOKFUzvOwIHSltSbjDjIB0jDdYYosRyj9j5NoTylhNWqSxT9zyN5yMJL3LumDI9IHTr
 OS/Q==
X-Gm-Message-State: APjAAAXBC0WHi1WoWIMpr1q/JIE1kfhT09N7Q3gbEABV/R2nbw4MneGf
 IkdsiOjdmwtprcUU/CtDAp4tEbn1rN2t4Mg5Qb9twEgOBAtQL43TdAenI3M1O7K4Iuo6U5twVZR
 eM3C0DgpEm+3I2qFHitNKPcVW
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596897wml.71.1579617645322; 
 Tue, 21 Jan 2020 06:40:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUkg5d8MSonCO4Ge0L397jZ+4TsON4lVJzpAggAw2WjkJCWhAHkQt1Jw0IPvgT93BvWQD3aw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596848wml.71.1579617645022; 
 Tue, 21 Jan 2020 06:40:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id b67sm4417502wmc.38.2020.01.21.06.40.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 06:40:44 -0800 (PST)
Subject: Re: [PATCH 07/14] KVM: x86/mmu: Walk host page tables to find THP
 mappings
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-8-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e9987a2-c34f-362d-a123-7dc4849811d1@redhat.com>
Date: Tue, 21 Jan 2020 15:40:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-8-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: _Zf8drMGMU-IKtS0u_ZdZw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
 Barret Rhoden <brho@google.com>, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Jason Zeng <jason.zeng@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 08/01/20 21:24, Sean Christopherson wrote:
> +
> +	/*
> +	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
> +	 * "writable" check in __gfn_to_hva_many(), which will always fail on
> +	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
> +	 * page fault steps have already verified the guest isn't writing a
> +	 * read-only memslot.
> +	 */
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!memslot_valid_for_gpte(slot, true))
> +		return PT_PAGE_TABLE_LEVEL;
> +
> +	hva = __gfn_to_hva_memslot(slot, gfn);
> +

Using gfn_to_memslot_dirty_bitmap is also a good excuse to avoid
kvm_vcpu_gfn_to_hva.

+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
+	if (!slot)
+		return PT_PAGE_TABLE_LEVEL;
+
+	hva = __gfn_to_hva_memslot(slot, gfn);

(I am planning to remove gfn_to_hva_memslot so that __gfn_to_hva_memslot
can lose the annoying underscores).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
