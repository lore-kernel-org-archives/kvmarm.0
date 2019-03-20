From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Wed, 20 Mar 2019 16:42:40 +0800
Message-ID: <20190320084240.GA17539@leoy-ThinkPad-X240s>
References: <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
 <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
 <20190315093748.GA20568@leoy-ThinkPad-X240s>
 <adde331f-1be9-2f0c-435a-bd906e0f253f@redhat.com>
 <0e58d46a-a076-e7b6-9b14-6bbefa2ef404@arm.com>
 <20190316045632.GA5330@leoy-ThinkPad-X240s>
 <f245a401-163c-7819-9af5-4226b0ac5f25@arm.com>
 <20190319013358.GA3374@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B494A2E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 04:42:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JKzG48hEauad for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 04:42:47 -0400 (EDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com
 [209.85.167.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A2904A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 04:42:47 -0400 (EDT)
Received: by mail-oi1-f172.google.com with SMTP id t206so1158599oib.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 01:42:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190319013358.GA3374@leoy-ThinkPad-X240s>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Robin Murphy <robin.murphy@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 19, 2019 at 09:33:58AM +0800, Leo Yan wrote:

[...]

> So far, it still cannot work well if I only set "sky2.disable_msi=1"
> for host kernel command line, with this config it runs with below flow
> and which cannot forward interrupt properly from host to guest:
> 
>     host                    guest
> 
>   INTx mode               msi enable
>                           msi disable
>                           Switch back to INTx mode

Just for heading up, for enabling vfio-pci with NIC device on Juno
board, I sent out two patch set for related changes.  With these
changes, the INTx mode can work well and it also can handle for up
failure case.

  kvmtool changes:
  https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/035186.html

  Juno DT binding for PCIe SMMU:
  https://archive.armlinux.org.uk/lurker/message/20190320.083105.f002c91c.en.html

@Robin, if you find issue for Juno DT binding in my patch and want to
send your patch for related fixing, please feel free let me know.  I
am happy to test it and drop my own.  Thanks!

Thanks,
Leo Yan
