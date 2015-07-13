From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: Re: [PATCH] KVM: Add Kconfig option to signal cross-endian guests
Date: Mon, 13 Jul 2015 11:24:08 +0200
Message-ID: <20150713112408.060164e1@bahia.local>
References: <20150707195012-mutt-send-email-mst@redhat.com>
 <1436428145-29823-1-git-send-email-thuth@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC2A586B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 05:14:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vfCGv4ZBfapy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2015 05:14:32 -0400 (EDT)
Received: from e06smtp17.uk.ibm.com (e06smtp17.uk.ibm.com [195.75.94.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A36B1586B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 05:14:32 -0400 (EDT)
Received: from /spool/local
 by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <gkurz@linux.vnet.ibm.com>;
 Mon, 13 Jul 2015 10:26:15 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7C7F01B082CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 10:25:27 +0100 (BST)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com
 [9.149.37.212])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t6D9OELU36634674
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 09:24:14 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t6D9OD5W001120
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 03:24:14 -0600
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
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org, virtualization@lists.linux-foundation.org, Marc Zyngier <marc.zyngier@arm.com>, Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu,  9 Jul 2015 09:49:05 +0200
Thomas Huth <thuth@redhat.com> wrote:

> The option for supporting cross-endianness legacy guests in
> the vhost and tun code should only be available on systems
> that support cross-endian guests.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
