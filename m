From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/2] kvm: introduce kvm_arch_msi_data_to_gsi
Date: Fri, 10 Apr 2015 11:10:47 +0200
Message-ID: <20150410091047.GB6186@cbox>
References: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
 <1428652090-5354-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C955A4C01A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:03:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l3XwmSojEcKz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 05:03:08 -0400 (EDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59EBE4C017
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:03:07 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so8714479lab.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 02:10:45 -0700 (PDT)
Content-Disposition: inline
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
Cc: james.hogan@imgtec.com, eric.auger@st.com, patches@linaro.org, aik@ozlabs.ru, qemu-devel@nongnu.org, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 10, 2015 at 08:48:09AM +0100, Eric Auger wrote:
> On ARM the MSI data corresponds to the shared peripheral interrupt (SPI)
> ID. This latter equals to the SPI index + 32. to retrieve the SPI index,
> matching the gsi, an architecture specific function is introduced.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
