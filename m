From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v14 01/10] linux-headers: update headers according to
 4.1-rc1
Date: Wed, 29 Apr 2015 17:19:20 +0200
Message-ID: <20150429171920.5cbfb7c7.cornelia.huck@de.ibm.com>
References: <1430319127-25907-1-git-send-email-eric.auger@linaro.org>
 <1430319127-25907-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 502934EF41
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 11:11:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ZtFEUVFdDv7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 11:11:00 -0400 (EDT)
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09BA74EF35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 11:10:59 -0400 (EDT)
Received: from /spool/local
 by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <cornelia.huck@de.ibm.com>;
 Wed, 29 Apr 2015 16:19:26 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com
 (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0220717D805D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 16:20:05 +0100 (BST)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com
 [9.149.37.250])
 by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t3TFJNGe9372086
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 15:19:23 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t3TFJM4J023591
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 09:19:23 -0600
In-Reply-To: <1430319127-25907-2-git-send-email-eric.auger@linaro.org>
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
Cc: peter.crosthwaite@xilinx.com, eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, borntraeger@de.ibm.com, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 29 Apr 2015 15:51:58 +0100
Eric Auger <eric.auger@linaro.org> wrote:

> This updates linux-headers against master 4.1-rc1 (commit
> b787f68c36d49bb1d9236f403813641efa74a031).
> 
> This includes, among other things, VFIO platform driver and
> irqfd/arm.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> v13 -> v14:
> - update to precise 4.1-rc1, precise the commit and change the title
> 
> v12 -> v13:
> - update for 4.1-rc0 headers
> 
> v10 -> v11:
> - only includes header modifications related to vfio platform
>   driver v14 and not those related to
>   "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1"
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  include/standard-headers/linux/virtio_balloon.h |  28 +++-
>  include/standard-headers/linux/virtio_blk.h     |   8 +-
>  include/standard-headers/linux/virtio_ids.h     |   1 +
>  linux-headers/asm-arm/kvm.h                     |   9 +-
>  linux-headers/asm-arm64/kvm.h                   |   9 +-
>  linux-headers/asm-mips/kvm.h                    | 164 +++++++++++++++---------
>  linux-headers/asm-s390/kvm.h                    |   4 +
>  linux-headers/asm-x86/hyperv.h                  |   2 +
>  linux-headers/linux/kvm.h                       |  66 +++++++++-
>  linux-headers/linux/vfio.h                      |   2 +
>  10 files changed, 223 insertions(+), 70 deletions(-)

Not trying to be a pain, but have you figured out why the virtio-input
header is missing for you?
