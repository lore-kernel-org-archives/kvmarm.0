From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v2 1/2] kvm: introduce kvm_arch_msi_data_to_gsi
Date: Fri, 10 Apr 2015 12:50:45 +0200
Message-ID: <20150410125045.4985585d.cornelia.huck@de.ibm.com>
References: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
 <1428652090-5354-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 668C44C072
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 06:43:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJ7OkDUTXKsr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 06:43:12 -0400 (EDT)
Received: from e06smtp17.uk.ibm.com (e06smtp17.uk.ibm.com [195.75.94.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03B964C071
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 06:43:11 -0400 (EDT)
Received: from /spool/local
 by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <cornelia.huck@de.ibm.com>;
 Fri, 10 Apr 2015 11:50:49 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6EE0F219005E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 11:50:34 +0100 (BST)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com
 [9.149.37.250])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t3AAom3A10813858
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 10:50:48 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t3AAolMb022650
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 04:50:48 -0600
In-Reply-To: <1428652090-5354-2-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: james.hogan@imgtec.com, eric.auger@st.com, patches@linaro.org, aik@ozlabs.ru, qemu-devel@nongnu.org, borntraeger@de.ibm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 10 Apr 2015 08:48:09 +0100
Eric Auger <eric.auger@linaro.org> wrote:

> On ARM the MSI data corresponds to the shared peripheral interrupt (SPI)
> ID. This latter equals to the SPI index + 32. to retrieve the SPI index,
> matching the gsi, an architecture specific function is introduced.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v1 -> v2:
> - abort on i386/mips/s390x since those archs do not support
>   kvm_gsi_direct_mapping
> ---
>  include/sysemu/kvm.h | 2 ++
>  kvm-all.c            | 2 +-
>  target-arm/kvm.c     | 5 +++++
>  target-i386/kvm.c    | 5 +++++
>  target-mips/kvm.c    | 5 +++++
>  target-ppc/kvm.c     | 5 +++++
>  target-s390x/kvm.c   | 5 +++++
>  7 files changed, 28 insertions(+), 1 deletion(-)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
