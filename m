From: David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 00/55] Nested Virtualization on KVM/ARM
Date: Mon, 9 Jan 2017 16:05:01 +0100
Message-ID: <7991b5fa-cbd3-a3b3-3f1c-8b8655ebdcfd@redhat.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


> Even though this work is not complete (see limitations below), I'd appreciate
> early feedback on this RFC. Specifically, I'm interested in:
> - Is it better to have a kernel config or to make it configurable at runtime?

x86 and s390x have a kernel module parameter (nested) that can only be
changed when loading the module and should default to false. So the
admin explicitly has to enable it. Maybe going the same path makes
sense.

-- 

David
