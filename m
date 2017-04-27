From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 4/8] Makefiles: use explicit path for
 including sub-Makefiles
Date: Thu, 27 Apr 2017 17:54:44 +0200
Message-ID: <328f9a03-d6ec-2d3a-af41-e107b4651fea@redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-5-alex.bennee@linaro.org>
 <20170407122010.umftrqr2qqd6g3q4@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B985343C73
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 11:51:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p28qIRsJg9cY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 11:51:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BE3E43C6E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 11:51:57 -0400 (EDT)
In-Reply-To: <20170407122010.umftrqr2qqd6g3q4@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 07/04/2017 14:20, Andrew Jones wrote:
>> -LIBFDT_objdir = lib/libfdt
>> -LIBFDT_srcdir = lib/libfdt
>> +LIBFDT_objdir = $(SRCDIR)/lib/libfdt
>> +LIBFDT_srcdir = $(SRCDIR)/lib/libfdt
>>  LIBFDT_archive = $(LIBFDT_objdir)/libfdt.a
>>  LIBFDT_include = $(addprefix $(LIBFDT_srcdir)/,$(LIBFDT_INCLUDES))
>>  LIBFDT_version = $(addprefix $(LIBFDT_srcdir)/,$(LIBFDT_VERSION))
> Can't we just do VPATH += $LIBFDT_srcdir instead?

That would search for every file in the lib/libfdt subdirectory of the
source directory, while here the desired prefix is just $(SRCDIR).

Paolo
