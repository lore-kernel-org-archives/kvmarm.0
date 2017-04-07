From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC kvm-unit-tests PATCH 1/8] configure: make it run-able from
 outside source tree
Date: Fri, 7 Apr 2017 12:46:25 +0100
Message-ID: <CAFEAcA-5kVogf1CJ_uzzf974-+V0-k-WTyF3AbNjWjYAHNz3hw@mail.gmail.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org> <20170406190727.5624-2-alex.bennee@linaro.org>
 <20170407114053.powj76325kjseqek@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170407114053.powj76325kjseqek@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 April 2017 at 12:40, Andrew Jones <drjones@redhat.com> wrote:
> On Thu, Apr 06, 2017 at 08:07:20PM +0100, Alex Benn=C3=A9e wrote:
>> diff --git a/configure b/configure
>> index 8821f37..223809c 100755
>> --- a/configure
>> +++ b/configure
>> @@ -1,5 +1,6 @@
>>  #!/bin/bash
>>
>> +srcdir=3D$(cd "$(dirname "$0")"; pwd)
>
> Why not just $(dirname "$0")? Any reason the path can't
> be relative?  Also, could use realpath vs. the cd/pwd.

Having srcdir be maybe relative and maybe absolute seems
like a recipe for confusion later on to me -- much better
for it to always be an absolute path, I think.
(Compare how QEMU's configure is careful to absolutize
the source_path variable.)

realpath isn't portable (not on OSX, for instance).

thanks
-- PMM
