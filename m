Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFE8C3F68F
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:16:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D18121927
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D18121927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88594A598;
	Fri,  7 Feb 2020 11:16:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JhLWlXTs6Cbc; Fri,  7 Feb 2020 11:15:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3184A4A3;
	Fri,  7 Feb 2020 11:15:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A6E4A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:15:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LLWWSl4Tu4Dk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:15:56 -0500 (EST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56A064A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:15:56 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 07 Feb 2020 08:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; d="scan'208";a="226515846"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2020 08:15:53 -0800
Date: Fri, 7 Feb 2020 08:15:53 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207161553.GE2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com>
 <20200207160546.GA707371@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200207160546.GA707371@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
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

On Fri, Feb 07, 2020 at 11:05:46AM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 07:38:29AM -0800, Sean Christopherson wrote:
> > On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> > > This patch is tested so I believe this works, however normally I need
> > > to do similar thing with [0] otherwise gcc might complaint.  Is there
> > > any trick behind to make this work?  Or is that because of different
> > > gcc versions?
> > 
> > array[] and array[0] have the same net affect, but array[] is given special
> > treatment by gcc to provide extra sanity checks, e.g. requires the field to
> > be the end of the struct.  Last I checked, gcc also doesn't allow array[]
> > in unions.  There are probably other restrictions.
> > 
> > But, it's precisely because of those restrictions that using array[] is
> > preferred, as it provides extra protections, e.g. if someone moved memslots
> > to the top of the struct it would fail to compile.
> 
> However...
> 
> xz-x1:tmp $ cat a.c
> struct a {
>     int s[];
> };
> 
> int main(void) { }
> xz-x1:tmp $ make a
> cc     a.c   -o a
> a.c:2:9: error: flexible array member in a struct with no named members
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

gcc is telling you quite explicitly why it's angry.  Copy+paste from the
internet[*]:

  Flexible Array Member(FAM) is a feature introduced in the C99 standard of the
  C programming language.

  For the structures in C programming language from C99 standard onwards, we
  can declare an array without a dimension and whose size is flexible in nature.

  Such an array inside the structure should preferably be declared as the last 
  member of structure and its size is variable(can be changed be at runtime).
  
  The structure must contain at least one more named member in addition to the
  flexible array member. 

[*] https://www.geeksforgeeks.org/flexible-array-members-structure-c/

>     2 |     int s[];
>       |         ^
> make: *** [<builtin>: a] Error 1
> 
> My gcc version is 9.2.1 20190827 (Red Hat 9.2.1-1) (GCC).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
