From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC 00/55] Nested Virtualization on KVM/ARM
Date: Tue, 10 Jan 2017 11:18:21 -0500
Message-ID: <CAHyh4xg23zgqzJa9yUgXdjZN5v45fBLjDFJok_DPSWUo9UaewQ@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <7991b5fa-cbd3-a3b3-3f1c-8b8655ebdcfd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 059EA4044B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:16:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k0-q5+4nNj7S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 11:16:42 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B9A74027C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:16:41 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0AGIP7X058981
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:18:25 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 4999786
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:18:25 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 7E7A691
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:18:24 -0500 (EST)
Received: from mail-oi0-f72.google.com (mail-oi0-f72.google.com
 [209.85.218.72])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0AGIOoW024437
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:18:24 -0500
Received: by mail-oi0-f72.google.com with SMTP id u143so278043680oif.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 08:18:24 -0800 (PST)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com.
 [209.85.218.41])
 by smtp.gmail.com with ESMTPSA id h74sm1062901oic.9.2017.01.10.08.18.22
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 10 Jan 2017 08:18:22 -0800 (PST)
Received: by mail-oi0-f41.google.com with SMTP id b126so735737620oia.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 08:18:22 -0800 (PST)
In-Reply-To: <7991b5fa-cbd3-a3b3-3f1c-8b8655ebdcfd@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <david@redhat.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 9, 2017 at 10:05 AM, David Hildenbrand <david@redhat.com> wrote:
>
>> Even though this work is not complete (see limitations below), I'd
>> appreciate
>> early feedback on this RFC. Specifically, I'm interested in:
>> - Is it better to have a kernel config or to make it configurable at
>> runtime?
>
>
> x86 and s390x have a kernel module parameter (nested) that can only be
> changed when loading the module and should default to false. So the
> admin explicitly has to enable it. Maybe going the same path makes
> sense.

I think that makes sense. Thanks!

>
> --
>
> David
>
