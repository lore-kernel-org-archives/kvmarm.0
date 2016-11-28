From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test
 cases
Date: Mon, 28 Nov 2016 12:58:24 +0100
Message-ID: <20161128115824.hrofgivt2mlfk7fh@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161128103744.s3wq53xzsxvu5uus@kamzik.brq.redhat.com>
 <878ts3uac6.fsf@linaro.org>
 <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, MTTCG Devel <mttcg@greensocs.com>, Mark Burton <mark.burton@greensocs.com>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Claudio Fontana <claudio.fontana@huawei.com>, Alvise Rigo <a.rigo@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, "Emilio G. Cota" <cota@braap.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Fedorov Sergey <serge.fdrv@gmail.com>, Pranith Kumar <bobby.prani@gmail.com>, KONRAD =?iso-8859-1?Q?Fr=E9d=E9ric?= <fred.konrad@greensocs.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christof
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 28, 2016 at 11:14:48AM +0000, Peter Maydell wrote:
> On 28 November 2016 at 11:12, Alex Bennée <alex.bennee@linaro.org> wrote:
> >
> > Andrew Jones <drjones@redhat.com> writes:
> >> I've skimmed over everything looking at it from a framwork/sytle
> >> perspective. I didn't dig in trying to understand the tests though.
> >> One general comment, I see many tests introduce MAX_CPUS 8. Why do
> >> that? Why not allow all cpus by using NR_CPUS for the array sizes?
> >
> > Yeah - I can fix those. I wonder what the maximum is with GIC V3?
> 
> So large that you don't want to hardcode it as an array size...

255 with the gic series, not yet merged. Even if you have a dozen arrays
with that as the size, then unless your array element size is huge (on
the order multiple pages), then it probably doesn't matter. Using the
default memory allocation of a QEMU guest, 128 MB, unit tests have plenty
of memory at their disposal. The framework itself only allocates a handful
of pages.

Of course the framework also supports dynamic memory allocation, so you
could do malloc(nr_cpus * element_size), to avoid excess.

Thanks,
drew
