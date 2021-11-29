Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A836C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 17:55:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058EE4B1BD;
	Mon, 29 Nov 2021 12:55:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 74KvC+XL5AhM; Mon, 29 Nov 2021 12:55:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 999764B1AC;
	Mon, 29 Nov 2021 12:55:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E48EE4B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:55:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHvYu1T50BRS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 12:55:23 -0500 (EST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1931D4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:55:23 -0500 (EST)
Received: by mail-ed1-f41.google.com with SMTP id o20so75053621eds.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 09:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Jo8G3WIFnCXJv/Wl58UbY8LXKhGKq56nydp8ornyGvw=;
 b=AjLExKPDvZxJIAf93isJIQG5owoNwi20rpmLOoVH2+s0ZWunJFmYMjECqAXAa31ExM
 qP4APhy58+cgNzSgs7CZp9bi9ZLfh1Um4f0T4CPKtFMqEQtoIPcbCG5ECCW+4/RpN3qP
 1k3CIsFPt6dBLkWzV5yOedKG0phAVvwwuaHgAci5hCbOZz8Yy6GMFp/NPR+R+K6sin3x
 5VGYrAKTVs66DntrIpjFBpn/bDtGwX2tdoIaZvud6hNaP1K0MD3EhI9p5XlWWUFTNrfc
 xT0cVpHPnGNOA0p342OPsO0F8T5HlLM3fktULYfIDujE1Zx4qHlH1POPSzpbzwUrncLW
 GVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Jo8G3WIFnCXJv/Wl58UbY8LXKhGKq56nydp8ornyGvw=;
 b=GxWC6/msgbZeB8HVJUCZhyVBUs2ZBTLZZaGbUKdYo+8VKwzRdG5VnUZX+C1FKmfbPC
 GlvJ2OSHeQR6l1NF2CjpYFpaEEigtYhtrrETWLaDrJzoysOYNdbwhQJFDdXpeHOesdgD
 jeZMhKDGllpWgC4VM1N71QOXFNZw28N2DRBXCvt0GyBXgbwYDct2Q4ZmFNtWKt1rMrxF
 zUBuYmfOmZsplLBx7FaetC0ZAY7Ruzg3phqbF7l6qt1c2vb66/BAoB0W7lzSnKIslZpS
 BZSHjsBJOYDard58iL+LT4Yd9RvR6xeVenrUXlnDQzVKCWsOy2SuDjd2EM5lC9qNgg5j
 zOKw==
X-Gm-Message-State: AOAM530oy9oLs243IAUo+DCjMbK1iCsbrgjMoin4nnT1okQIV31brN5f
 LrEl5mj31OA+IM+TII1wgzw=
X-Google-Smtp-Source: ABdhPJzV0Hp7Xr2kSqyy1FejCYUnhDh4xLCC02qQtKZ+cbHbGKkW71ueP1pw91X6C27D1KEW8+5Gvw==
X-Received: by 2002:a17:907:68e:: with SMTP id
 wn14mr62415481ejb.258.1638208522107; 
 Mon, 29 Nov 2021 09:55:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id og38sm7559529ejc.5.2021.11.29.09.55.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 29 Nov 2021 09:55:21 -0800 (PST)
Message-ID: <ba8341d6-7ee7-1af1-1385-0a9226bbf952@redhat.com>
Date: Mon, 29 Nov 2021 18:55:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUNBfJh35WXMV0M@google.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/29/21 18:25, Sean Christopherson wrote:
>> If I apply though only the patch series up to this patch, my fedora VM seems
>> to work fine, but my windows VM still locks up hard when I run 'LatencyTop'
>> in it, which doesn't happen without this patch.
> 
> Buy "run 'LatencyTop' in it", do you mean running something in the Windows guest?
> The only search results I can find for LatencyTop are Linux specific.

I think it's LatencyMon, https://www.resplendence.com/latencymon.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
