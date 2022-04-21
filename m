Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7227C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 13:22:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E27F4B235;
	Thu, 21 Apr 2022 09:22:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id saTe7Vx8tq3Z; Thu, 21 Apr 2022 09:22:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD4F4B175;
	Thu, 21 Apr 2022 09:22:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19ED84B10B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:22:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dRtmtui6EkAX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 09:21:59 -0400 (EDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
 [209.85.218.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11E454B0DE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:21:59 -0400 (EDT)
Received: by mail-ej1-f48.google.com with SMTP id y20so9996940eju.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bXKpCYOj7t5BTPU5Wz9Ftw9cLOsid4GfV8dHQSkHd4o=;
 b=joRBLzIQeXqtjzT9eaoBB9pMC8QXEJyX4Tvbdj14LJYa8ePIyVTTUx6BsluwFjnR1/
 HEypwr6hZPa9K51uwAM+mqB+4jCKf/HL6QYDsPSPHeBplmqqCCkSouKRgcxR7oXU+LZy
 JnCdjEb5abHlvdkHEy0yTCTsj6v8oXeDODKtTz1Z9MRmLCL5o7EgzBaKYqVXMgnAVBTi
 glNS6gATueFfFmQpvMxE0CyfSvrd+ySR0fTuSXemP7mP9yEXPsxZwITUyFbJ3LJiIEpY
 kBdhSVUmzoOl18V0Q5eTPLHb5w6h0tYMNzxun41SeG79AYgp7mY5A5gTwSJyUEzIuTXf
 CgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bXKpCYOj7t5BTPU5Wz9Ftw9cLOsid4GfV8dHQSkHd4o=;
 b=TrO+mf4mDgh97vZWk7kKZ+pC2oPnej9dUPWl0JJ3c2g2bsHKUTOhwPz7xedPP59WEg
 XRmquk+/b9cntgq6cmUAECgLnd2QQh/3W6aT9PMnEre5wWYxFMezsusx1+xq/nc0/hwH
 itLhsrSzvhyaWk6i+LipNfvME1VwkB1CoQC+C/UW4iMeEV6oBjrkGic96SpjdS48xfur
 pQgVrMapHt7Duy0n7ACstVp90FatO53Sf9Fy2XSAoWEEao4AfaOICsccrmYbL3XidDOU
 IFjX82XLsNyj0zznfbxGzgws9UCym4cQAj/4fKZkL6igznuVDn+VEGX7OWaB6L3I8Ifk
 1vrQ==
X-Gm-Message-State: AOAM532tLKuRjNGce+2FaCrN2gRAAZAYcYGXDrmA5uz6qRK16OZ1m8Ne
 TitJ5q+D+L92LAG0jqJZ97pq0w==
X-Google-Smtp-Source: ABdhPJx1L9hShjNwK94hggJJiK6IFYK/sCAP5IkmWVOxrAJcbXpmJ83JIVZImsLcCV+kjJl8XfiyJA==
X-Received: by 2002:a17:906:8554:b0:6e8:c43c:12b3 with SMTP id
 h20-20020a170906855400b006e8c43c12b3mr22510752ejy.331.1650547317768; 
 Thu, 21 Apr 2022 06:21:57 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com.
 [34.91.171.30]) by smtp.gmail.com with ESMTPSA id
 d11-20020a056402400b00b00423e5bdd6e3sm6063712eda.84.2022.04.21.06.21.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Apr 2022 06:21:57 -0700 (PDT)
Date: Thu, 21 Apr 2022 13:21:54 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmFactP0GnSp3vEv@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-10-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On Friday 15 Apr 2022 at 21:58:53 (+0000), Oliver Upton wrote:
> Breaking a table pte is insufficient to guarantee ownership of an
> unlinked subtree. Parallel software walkers could be traversing
> substructures and changing their mappings.
> 
> Recurse through the unlinked subtree and lock all descendent ptes
> to take ownership of the subtree. Since the ptes are actually being
> evicted, return table ptes back to the table walker to ensure child
> tables are also traversed. Note that this is done both in both the
> pre-order and leaf visitors as the underlying pte remains volatile until
> it is unlinked.

Still trying to get the full picture of the series so bear with me. IIUC
the case you're dealing with here is when we're coallescing a table into
a block with concurrent walkers making changes in the sub-tree. I
believe this should happen when turning dirty logging off?

Why do we need to recursively lock the entire sub-tree at all in this
case? As long as the table is turned into a locked invalid PTE, what
concurrent walkers are doing in the sub-tree should be irrelevant no?
None of the changes they do will be made visible to the hardware anyway.
So as long as the sub-tree isn't freed under their feet (which should be
the point of the RCU protection) this should be all fine? Is there a
case where this is not actually true?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
