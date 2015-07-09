From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] KVM: Add Kconfig option to signal cross-endian guests
Date: Thu, 9 Jul 2015 14:21:54 +0200
Message-ID: <20150709142154.5561fa16.cornelia.huck@de.ibm.com>
References: <20150707195012-mutt-send-email-mst@redhat.com>
 <1436428145-29823-1-git-send-email-thuth@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDEB558345
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 08:10:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LKxbYhwhurNb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 08:10:26 -0400 (EDT)
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E52AF58341
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 08:10:25 -0400 (EDT)
Received: from /spool/local
 by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <cornelia.huck@de.ibm.com>;
 Thu, 9 Jul 2015 13:21:59 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0A38D2190061
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 13:21:35 +0100 (BST)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com
 [9.149.37.228])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t69CLvP431850724
 for <kvmarm@lists.cs.columbia.edu>; Thu, 9 Jul 2015 12:21:57 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t69CLufk003090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 9 Jul 2015 06:21:56 -0600
In-Reply-To: <1436428145-29823-1-git-send-email-thuth@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Huth <thuth@redhat.com>
Cc: kraxel@redhat.com, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org, virtualization@lists.linux-foundation.org, Marc Zyngier <marc.zyngier@arm.com>, Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Greg Kurz <gkurz@linux.vnet.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu,  9 Jul 2015 09:49:05 +0200
Thomas Huth <thuth@redhat.com> wrote:

> The option for supporting cross-endianness legacy guests in

s/cross-endianness/cross-endian/ ?

> the vhost and tun code should only be available on systems
> that support cross-endian guests.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arch/arm/kvm/Kconfig     | 1 +
>  arch/arm64/kvm/Kconfig   | 1 +
>  arch/powerpc/kvm/Kconfig | 1 +
>  drivers/net/Kconfig      | 1 +
>  drivers/vhost/Kconfig    | 1 +
>  virt/kvm/Kconfig         | 3 +++
>  6 files changed, 8 insertions(+)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
