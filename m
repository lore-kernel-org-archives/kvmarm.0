From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 2/2] KVM: Protect device ops->create and list_add with
 kvm->lock
Date: Wed, 10 Aug 2016 12:28:41 +0200
Message-ID: <209d8ccd-e53d-6fc8-e078-f4d48db5c8ca@de.ibm.com>
References: <20160809171301.24283-1-christoffer.dall@linaro.org>
 <20160809171301.24283-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54572412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 06:21:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OofDJMXn-9TD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2016 06:21:38 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B0B5410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 06:21:37 -0400 (EDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
 u7AAO9FV085740
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 06:28:46 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
 by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9sy37j-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 06:28:46 -0400
Received: from localhost
 by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Wed, 10 Aug 2016 11:28:44 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 24DFA17D8042
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 11:30:22 +0100 (BST)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com
 [9.149.37.251])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 u7AASgG721823740
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 10:28:42 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 u7A9SiuN022816
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 03:28:44 -0600
In-Reply-To: <20160809171301.24283-3-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>, paulus@ozlabs.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/09/2016 07:13 PM, Christoffer Dall wrote:
> KVM devices were manipulating list data structures without any form of
> synchronization, and some implementations of the create operations also
> suffered from a lack of synchronization.
> 
> Now when we've split the xics create operation into create and init, we
> can hold the kvm->lock mutex while calling the create operation and when
> manipulating the devices list.
> 
> The error path in the generic code gets slightly ugly because we have to
> take the mutex again and delete the device from the list, but holding
> the mutex during anon_inode_getfd or releasing/locking the mutex in the
> common non-error path seemed wrong.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Looks sane for s390.
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
