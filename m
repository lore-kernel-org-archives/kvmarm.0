From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: Extensions for KVM MSI related ioctls
Date: Mon, 13 Jul 2015 15:29:45 +0100
Message-ID: <55A3CB59.80906@arm.com>
References: <55A39231.4050904@arm.com> <55A3B090.6090002@redhat.com>
 <03b901d0bd70$6c2f4b50$448de1f0$@samsung.com> <55A3CA17.1010500@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5632C586EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 10:17:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gcu4P1F0zcoZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2015 10:17:57 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBEC0586E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 10:17:55 -0400 (EDT)
In-Reply-To: <55A3CA17.1010500@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Pavel Fedin <p.fedin@samsung.com>, 'Paolo Bonzini' <pbonzini@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 'Gleb Natapov' <gleb@kernel.org>, 'Jan Kiszka' <jan.kiszka@siemens.com>, 'Marcelo Tosatti' <mtosatti@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 13/07/15 15:24, Eric Auger wrote:
> On 07/13/2015 03:32 PM, Pavel Fedin wrote:
>>  Hello!
>>
>>> I think I prefer the flag.  Offhand it sounds easier to add support for
>>> it to non-ARM architectures, compared to KVM_IRQ_ROUTING_EXTENDED_MSI.
>>
>>  Actually i also voted for flag, because it is already introduced in (2), and i'm not a fan of
>> adding new definitions where we can reuse existing ones. IMHO using flag would make an API more
>> consistent.
> 
> OK I will respin with user space flag.
> 
> Andre, what about the kernel routing entry struct. You wanted me to get
> rid of  KVM_IRQ_ROUTING_EXTENDED_MSI there too. Will you be able to
> manage a usespace wrong setting if the type is not set?

I am about to see how this all fits together, but I don't expect any
serious problems, at least on the kvmtool side.
Instead of setting a different type I just set the flag and guard that
by the capability: should be not an issue.

Cheers,
Andre.
