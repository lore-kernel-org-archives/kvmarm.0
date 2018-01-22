From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Mon, 22 Jan 2018 19:32:12 +0000
Message-ID: <5A663C3C.7040904@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
 <506cd212-3d16-ba2a-518f-34982bc162fc@huawei.com> <5A58F8E3.5060002@arm.com>
 <CAMj-D2C5Bz3r-w9v3QasZKK-W2JBY7Mx9W=yCDBnPYyk99gGzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E3949D62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 14:29:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W-e8mz8pqwj0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jan 2018 14:29:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0196149D2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 14:29:19 -0500 (EST)
In-Reply-To: <CAMj-D2C5Bz3r-w9v3QasZKK-W2JBY7Mx9W=yCDBnPYyk99gGzA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: wuquanming <wuquanming@huawei.com>, linux-acpi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, rjw@rjwysocki.net, linux@armlinux.org.uk, gengdongjiu <gengdongjiu@huawei.com>, linuxarm@huawei.com, bp@alien8.de, arm-mail-list <linux-arm-kernel@lists.infradead.org>, pbonzini@redhat.com, Huangshaoyu <huangshaoyu@huawei.com>, kvmarm@lists.cs.columbia.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 21/01/18 02:45, gengdongjiu wrote:
> For the ESR_ELx_AET_UER, this exception is precise, closing the VM may
> be better[1].
> But if you think panic is better until we support kernel-first, it is
> also OK to me.

I'm not convinced SError while a guest was running means only guest memory could
be affected. Mechanisms like KSM means the error could affect multiple guests.

Both firmware-fist and kernel-first will give us the address, with which we can
know which processes are affected, isolated the memory and signal affected
processes.

Until we have one of these panic() is the only way we have to contain an error,
but its an interim fix.
Not panic()ing the host for an error that should be contained to the guest is a
fudge, we don't actually know its safe (KSM, page-table etc). I want to improve
on this with {firmware, kernel}-first support (or both!), I don't want to expose
that this is happening to user-space, as once we have one of {firmware,
kernel}-first, it shouldn't happen.


>> This is inventing something new for RAS errors not claimed by firmware-first.
>> If we have kernel-first too, this will never happen. (unless your system is
>> losing the error description).

> In fact, if we have kernel-first, I think we still need to judge the
> error type by ESR, right?

The kernel-first mechanism should consider the ESR/FAR, yes, but once the error
has been claimed and handled, KVM shouldn't care about any of these values.
(maybe we'll sanity check for uncontained errors, just in case the error escaped
to the RAS code...)

My point here was exposing 'unhandled' (ignored) RAS errors to user-space
creates an ABI: someone will complain once we start handling the error, and they
no longer get a notification via this 'unhandled' interface. Code written to use
this interface becomes useless/untested.


> If the handle_guest_sei() , may be the system does not support firmware-first,
> so we judge the ESR value,

...and panic()/ignore as appropriate.

I agree not all systems will support firmware-first, (big-endian is the obvious
example), but if we get kernel-first support this ESR guessing can disappear,
I'm against exposing it to user-space in the meantime.


Thanks,

James
